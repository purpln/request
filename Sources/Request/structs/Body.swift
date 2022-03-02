public struct Body: Equatable {
    public var data: [UInt8]
    public var boundary: String
    
    public init(data: [UInt8] = [], boundary: String = "") {
        self.data = data
        self.boundary = boundary
    }
}

public extension Body {
    static var none: Self { .init() }
}

extension Body {
    public init(data: [UInt8], file: String, name: String, type: String = "image/jpeg") {
        let uuid: String = .uuid
        var value: [UInt8] = []
        value.append(contentsOf: [UInt8]("\r\n--\(uuid)\r\n".utf8) )
        value.append(contentsOf: [UInt8]("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(file)\"\r\n".utf8) )
        value.append(contentsOf: [UInt8]("Content-Type: \(type)\r\n\r\n".utf8) )
        value.append(contentsOf: data)
        value.append(contentsOf: [UInt8]("\r\n--\(uuid)--\r\n".utf8) )
        self.init(data: value, boundary: uuid)
    }
}
