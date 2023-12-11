import class Foundation.JSONEncoder
import class Foundation.JSONDecoder
import class Foundation.NSObject
import class Foundation.OperationQueue
import class Foundation.URLSession
import class Foundation.HTTPURLResponse
import class Foundation.URLSessionTask
import class Foundation.URLSessionConfiguration
import class Foundation.URLSessionDownloadTask
import protocol Foundation.URLSessionDownloadDelegate
import struct Foundation.URLRequest
import struct Foundation.URL
import struct Foundation.Data

public extension Response {
    static var decoder = JSONDecoder()
    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        guard case .bytes(let bytes) = body else {
            throw NetworkError.emptyBody
        }
        return try Response.decoder.decode(type, from: Data(bytes))
    }
}

public extension Request {
    static var encoder = JSONEncoder()
    func encode<T>(_ value: T) throws -> Self where T: Encodable {
        let bytes = [UInt8](try Request.encoder.encode(value))
        let body: Body = .bytes(bytes)
        var headers = headers
        headers.append(key: "Content-Type", value: "application/json")
        return Request(link: link, headers: headers, method: .post, body: body)
    }
}

extension Request {
    public func load() async throws -> Response { try await Network.shared.load(req: self) }
    
    public func load(to link: Linkage, progress: @escaping (Float) -> Void = { _ in }) async throws -> Response { try await Network.shared.load(req: self, to: link, progress: progress) }
}

public class Network: NSObject {
    public static var shared = Network()
    
    private var timeout: Double = 60
    
    var config: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeout
        config.timeoutIntervalForResource = timeout
        return config
    }
    
    func task(request: URLRequest) async -> (HTTPURLResponse?, Data?) {
        return await withCheckedContinuation { continuation in
            let task = URLSession(configuration: config).dataTask(with: request) { data, urlresponse, error in
                continuation.resume(returning: (urlresponse as? HTTPURLResponse, data))
            }
            task.resume()
        }
    }
}

extension Network {
    public func load(req: Request) async throws -> Response {
        let request = try req.request()
        let (response, data) = await task(request: request)
        guard let response, let data else { throw NetworkError.invalidResponse }
        
        let headers = response.allHeaderFields.reduce(into: [(String, String)]()) { array, element in
            array.append((String(describing: element.key), String(describing: element.value)))
        }
        
        return Response(status: .init(statusCode: response.statusCode), headers: .init(headers: headers), body: .bytes([UInt8](data)))
    }
}

extension Network {
    public func load(req: Request, to destination: Linkage, progress: @escaping (Float) -> Void = { _ in }) async throws -> Response {
        let request = try req.request()
        guard let path = destination.string, let url = URL(string: path) else { throw NetworkError.foundationUrl }
        guard let response = try await download(request: request, destination: url) else {
            throw NetworkError.invalidResponse
        }
        let headers = response.allHeaderFields.reduce(into: [(String, String)]()) { array, element in
            array.append((String(describing: element.key), String(describing: element.value)))
        }
        return Response(status: .init(statusCode: response.statusCode), headers: .init(headers: headers), body: .none)
    }
}

extension Network {
    public func download(request: URLRequest, destination url: URL, progress: @escaping (Float) -> Void = { _ in }) async throws -> HTTPURLResponse? {
        return await withCheckedContinuation { continuation in
            let delegate = DownloadDelegate(destination: url, progress: progress) { response in
                continuation.resume(returning: response)
            }
            URLSession(configuration: .default, delegate: delegate, delegateQueue: OperationQueue())
                .downloadTask(with: request)
                .resume()
        }
    }
}

class DownloadDelegate: NSObject, URLSessionDownloadDelegate {
    var destination: URL!
    var progress: (Float) -> Void = { _ in }
    var response: (HTTPURLResponse?) -> Void = { _ in }
    
    init(destination: URL, progress: @escaping (Float) -> Void = { _ in }, response: @escaping (HTTPURLResponse?) -> Void) {
        super.init()
        self.destination = destination
        self.progress = progress
        self.response = response
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        response(nil)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        response(downloadTask.response as? HTTPURLResponse)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        progress(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
    }
}

public enum NetworkError: Error {
    case invalidLink
    case invalidRequest
    case invalidResponse
    case foundationUrl
    case emptyBody
}

extension Request {
    public func request() throws -> URLRequest {
        guard var url = link.string else { throw NetworkError.invalidLink }
        
        if let new = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
            url = new.replacingOccurrences(of: "+", with: "%2B")
        }
        
        guard let link = URL(string: url) else { throw NetworkError.foundationUrl }
        var request = URLRequest(url: link)
        
        request.httpMethod = method.rawValue
        headers.headers.forEach { header in request.addValue(header.value, forHTTPHeaderField: header.key) }
        
        guard case .bytes(let bytes) = body else { return request }
        guard method != .get else { throw NetworkError.invalidRequest }
        
        request.httpBody = Data(bytes)
        
        return request
    }
}
