#if canImport(Foundation)
import Foundation
#endif
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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
    public func load() async throws -> Response {
        #if os(Linux)
        try await task(request: self)
        #else
        try await Network.shared.load(req: self)
        #endif
    }
    
    public func load(to link: Linkage, progress: @escaping (Float) -> Void = { _ in }) async throws -> Response {
        try await Network.shared.load(req: self, to: link, progress: progress)
    }
}

public class Network: NSObject {
    public static var shared = Network(timeout: 30)
    
    public var timeout: Double = 60
    
    public init(timeout: Double) {
        self.timeout = timeout
    }
    
    var config: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeout
        config.timeoutIntervalForResource = timeout
        return config
    }
    
    func task(request: URLRequest) async throws -> (HTTPURLResponse, Data) {
        try await withCheckedThrowingContinuation { continuation in
            let task = URLSession(configuration: config).dataTask(with: request) { data, urlresponse, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let urlresponse else {
                    continuation.resume(throwing: NetworkError.emptyResponse)
                    return
                }
                guard let data else {
                    continuation.resume(throwing: NetworkError.emptyBody)
                    return
                }
                guard let response = urlresponse as? HTTPURLResponse else {
                    continuation.resume(throwing: NetworkError.invalidResponse(urlresponse))
                    return
                }
                continuation.resume(returning: (response, data))
            }
            task.resume()
        }
    }
}

extension Network {
    public func load(req: Request) async throws -> Response {
        let request = try req.request()
        let (response, data) = try await task(request: request)
        
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
        let response = try await download(request: request, destination: url)
        let headers = response.allHeaderFields.reduce(into: [(String, String)]()) { array, element in
            array.append((String(describing: element.key), String(describing: element.value)))
        }
        return Response(status: .init(statusCode: response.statusCode), headers: .init(headers: headers), body: .none)
    }
}

extension Network {
    public func download(request: URLRequest, destination url: URL, progress: @escaping (Float) -> Void = { _ in }) async throws -> HTTPURLResponse {
        return try await withCheckedThrowingContinuation { continuation in
            let delegate = DownloadDelegate(destination: url, progress: progress) { urlresponse in
                guard let urlresponse else {
                    continuation.resume(throwing: NetworkError.emptyResponse)
                    return
                }
                guard let response = urlresponse as? HTTPURLResponse else {
                    continuation.resume(throwing: NetworkError.invalidResponse(urlresponse))
                    return
                }
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
    var response: (URLResponse?) -> Void = { _ in }
    
    init(destination: URL, progress: @escaping (Float) -> Void = { _ in }, response: @escaping (URLResponse?) -> Void) {
        super.init()
        self.destination = destination
        self.progress = progress
        self.response = response
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("network error:", error ?? "error - nil")
        Task {
            try await Task.sleep(nanoseconds: 1000)
            response(nil)
            response = { _ in }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let url = URL(fileURLWithPath: destination.path)
        try? FileManager.default.removeItem(atPath: url.path)
        
        let at = URL(fileURLWithPath: location.path)
        let to = URL(fileURLWithPath: destination.path)
        try? FileManager.default.moveItem(at: at, to: to)
        
        response(downloadTask.response)
        response = { _ in }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        progress(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
    }
}

public enum NetworkError: Error {
    case invalidLink
    case invalidRequest
    case invalidResponse(URLResponse)
    case nsErrorDomain(String)
    case foundationUrl
    case emptyResponse
    case emptyBody
}


extension NetworkError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalidLink: return "[Network] Invalid link"
        case .invalidRequest: return "[Network] Invalid request"
        case .invalidResponse(_): return "[Network] Invalid response"
        case .nsErrorDomain(let string): return "[Network] Network error \(string)"
        case .foundationUrl: return "[Network] Incorrect foundation url"
        case .emptyResponse: return "[Network] Empty response"
        case .emptyBody: return "[Network] Empty body"
        }
    }
}

extension Request {
    public func request() throws -> URLRequest {
        guard let url = link.string else { throw NetworkError.invalidLink }
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

#if os(Linux)

import AsyncHTTPClient

func task(request req: Request) async throws -> Response {
    let client = HTTPClient(eventLoopGroupProvider: .singleton)
    var request = HTTPClientRequest(url: req.link.description)
    request.method = .init(rawValue: req.method.rawValue)
    request.headers = .init(req.headers.headers)
    if case .bytes(let bytes) = req.body {
        request.body = .bytes(bytes, length: .known(bytes.count))
    }
    let response = try await client.execute(request, timeout: .seconds(30))
    let status = Status(statusCode: Int(response.status.code))
    let headers = Headers(headers: response.headers.reduce(into: [(String, String)](), { $0.append(($1.name, $1.value)) }))
    var buffer = try await response.body.collect(upTo: 1024 * 1024)
    let body: Body
    if let bytes = buffer.readBytes(length: buffer.readableBytes) {
        body = .bytes(bytes)
    } else {
        body = .none
    }
    return Response(status: status, headers: headers, body: body)
}

#endif
