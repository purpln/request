import Foundation

public protocol NetworkProtocol {
    func progress(value: Double)
    func location(value: URL)
    func speed(count: Int, time: Double)
}

public extension NetworkProtocol {
    func progress(value: Double) { }
    func location(value: URL) { }
    func speed(count: Int, time: Double) { }
}

open class Network: NSObject {
    public static var shared = Network()
    
    open var timeout: Double = 60
    
    open var config: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeout
        config.timeoutIntervalForResource = timeout
        return config
    }
    
    @discardableResult
    open func load(req: Request) -> URLSessionDataTask? {
        let beautifier: (Data?, URLResponse?, Error?) -> Response? = response
        
        guard let request = req.request else { return nil }
        let time = CFAbsoluteTimeGetCurrent()
        
        let task = URLSession(configuration: config).dataTask(with: request) { [weak self] data, resp, error in
            let current = CFAbsoluteTimeGetCurrent()
            guard let response = beautifier(data, resp, error) else { return }
            let count = response.data?.count ?? 0
            let speed = Double(count)/(current-time)
            self?.delegate?.speed(count: count, time: speed)
            if let completion = req.response { completion(response) }
        }
        
        task.resume()
        return task
    }
    
    open func load(reqs: [Request], pause: Double = 0, _ closure: (() -> Void)? = nil) {
        let beautifier: (Data?, URLResponse?, Error?) -> Response? = response
        
        let group = DispatchGroup()
        DispatchQueue.global(qos: .background).async {
            for req in reqs {
                group.enter()
                guard let request = req.request else { return }
                let time = CFAbsoluteTimeGetCurrent()
                
                let task = URLSession.shared.dataTask(with: request) { [weak self] data, resp, error in
                    defer {
                        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now()+pause) {
                            group.leave()
                        }
                    }
                    let current = CFAbsoluteTimeGetCurrent()
                    guard let response = beautifier(data, resp, error) else { return }
                    let count = response.data?.count ?? 0
                    let speed = Double(count)/(current-time)
                    self?.delegate?.speed(count: count, time: speed)
                    if let completion = req.response { completion(response) }
                }
                task.resume()
                group.wait()
            }
            group.notify(queue: .main) {
                closure?()
            }
        }
    }
    
    open var response: (Data?, URLResponse?, Error?) -> Response? = { data, resp, error in
        if let _ = error as? URLError {
            return nil
        } else if let resp = resp as? HTTPURLResponse {
            var response = Response(code: resp.statusCode)
            if let data = data { response.data = [UInt8](data) }
            response.headers = resp.allHeaderFields.reduce(into: [String:Any](), { $0[String(describing: $1.key)] = $1.value })
            if response.headers.count != resp.allHeaderFields.count {
                print("network error parsing headers")
                print(response.headers)
                print(resp.allHeaderFields)
            }
            return response
        }
        return nil
    }
    
    open var delegate: NetworkProtocol?
}

extension Network {
    @discardableResult public
    class func load(req: Request) -> URLSessionDataTask? {
        shared.load(req: req)
    }
    
    public class func load(reqs: [Request], _ closure: (() -> Void)? = nil) {
        shared.load(reqs: reqs, closure)
    }
}

extension Network: URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) { delegate?.location(value: location) }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) { delegate?.progress(value: Double(totalBytesWritten/totalBytesExpectedToWrite) ) }
}
