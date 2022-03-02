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
    public static var shared = Network()
    open var delegate: NetworkProtocol?
    
    @discardableResult open
    class func load(req: Request) -> URLSessionDataTask? {
        guard let request = req.request else { return nil }
        let task = URLSession.shared.dataTask(with: request) { data, resp, error in
            guard let resp = resp as? HTTPURLResponse else { return }
            var response = Response(code: resp.statusCode)
            if let data = data { response.data = [UInt8](data) }
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
