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
    func form(_ dictionary: [String: String]) -> Self {
        var request = self
        let string = dictionary
            .reduce(into: [String]()) { array, element in array.append("\(element.key)=\(element.value)") }
            .joined(separator: "&")
        let bytes = [UInt8](string.utf8)
        request.headers.append(key: "Content-Type", value: "application/x-www-form-urlencoded; charset=utf-8")
        request.headers.append(key: "Content-Length", value: "\(bytes.count)")
        request.body = .bytes(bytes)
        return request
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
