import Link

public typealias Linkage = Link.Linkage

public struct Request {
    public var link: Linkage
    public var headers: Headers
    public var method: Method
    public var body: Body
    
    public init(link: Linkage, headers: Headers = .none, method: Method = .get, body: Body = .none) {
        self.link = link
        self.headers = headers
        self.method = method
        self.body = body
    }
}

public extension Request {
    func file(_ bytes: [UInt8], boundary: String) -> Self {
        var request = self
        request.headers.append(key: "Content-Type", value: "multipart/form-data; boundary=\(boundary)")
        request.headers.append(key: "Content-Length", value: "\(bytes.count)")
        request.body = .bytes(bytes)
        return request
    }
}

public extension Request {
    static func from(file bytes: [UInt8], boundary: String, with link: Linkage, headers: Headers = .none, method: Method = .post) -> Self {
        var headers = headers
        headers.append(key: "Content-Type", value: "multipart/form-data; boundary=\(boundary)")
        headers.append(key: "Content-Length", value: "\(bytes.count)")
        let body: Body = .file(bytes: bytes, boundary: boundary)
        return Request(link: link, headers: headers, method: method, body: body)
    }
    
    static func from(json bytes: [UInt8], with link: Linkage, headers: Headers = .none, method: Method = .post) -> Self {
        var headers = headers
        headers.append(key: "Content-Type", value: "application/json")
        let body: Body = .bytes(bytes)
        return Request(link: link, headers: headers, method: method, body: body)
    }
}
