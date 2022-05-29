import Foundation

public protocol NetworkProtocol {
    func progress(value: Double)
    func location(value: URL)
}

extension NetworkProtocol {
    func progress(value: Double) { }
    func location(value: URL) { }
}

open class Network: NSObject {
    private class func response(_ data: Data?, _ resp: URLResponse?, _ error: Error?) -> Response? {
        guard let resp = resp as? HTTPURLResponse else { return nil }
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
    
    private static var config: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeout
        config.timeoutIntervalForResource = timeout
        return config
    }
    
    public static var shared = Network()
    open var delegate: NetworkProtocol?
    public static var timeout: Double = 30
    
    @discardableResult open
    class func load(req: Request) -> URLSessionDataTask? {
        guard let request = req.request else { return nil }
        let task = URLSession(configuration: config).dataTask(with: request) { data, resp, error in
            guard let response = response(data, resp, error) else { return }
            if let completion = req.response { completion(response) }
        }
        
        task.resume()
        return task
    }
    
    open class func load(reqs: [Request], _ closure: (() -> Void)? = nil) {
        let group = DispatchGroup()
        DispatchQueue.global(qos: .background).async {
            for req in reqs {
                guard let request = req.request else { return }
                let task = URLSession(configuration: config).dataTask(with: request) { data, resp, error in
                    guard let response = response(data, resp, error) else { return }
                    if let completion = req.response { completion(response) }
                    group.leave()
                }
                task.resume()
                group.wait()
            }
            group.notify(queue: .main) {
                closure?()
            }
        }
    }
    
    open class func queue(reqs: [(name: String, req: Request)],
                          next: (((name: String, req: Request)) -> (name: String, req: Request))? = nil,
                          closure: (() -> Void)? = nil) {
        let group = DispatchGroup()
        
        DispatchQueue.global(qos: .background).async {
            var reqs = reqs
            for i in 0..<reqs.count {
                guard let request = reqs[i].req.request else { continue }
                group.enter()
                let task = URLSession(configuration: config).dataTask(with: request) { data, resp, error in
                    guard let response = response(data, resp, error) else { return }
                    if let completion = reqs[i].req.response { completion(response) }
                    if i+1 < reqs.count, let req = next?(reqs[i+1]) { reqs[i+1] = req }
                    group.leave()
                }
                task.resume()
                group.wait()
            }
            group.notify(queue: .main) {
                closure?()
            }
        }
    }
}

extension Network {
    @discardableResult open
    func download(req: Request) -> URLSessionDownloadTask? {
        guard let request = req.request else { return nil  }
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let task = session.downloadTask(with: request) { data, resp, error in
            guard let resp = resp as? HTTPURLResponse else { return }
            var response = Response(code: resp.statusCode)
            if let url = data?.absoluteString { response.data = [UInt8](url.utf8) }
            response.headers = resp.allHeaderFields.reduce(into: [String:Any](), { $0[String(describing: $1.key)] = $1.value })
            
            if response.headers.count != resp.allHeaderFields.count {
                print("network error parsing headers")
                print(response.headers)
                print(resp.allHeaderFields)
            }
            
            if let completion = req.response { completion(response) }
        }
        
        task.resume()
        return task
    }
}

extension Network: URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) { delegate?.location(value: location) }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) { delegate?.progress(value: Double(totalBytesWritten/totalBytesExpectedToWrite) ) }
}
