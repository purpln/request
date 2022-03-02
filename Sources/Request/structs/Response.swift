public struct Response {
    public var code: Int
    public var error: [Error]?
    public var data: [UInt8]?
    public var headers: [AnyHashable: Any]?
}

public extension Response {
    var success: Bool { [200, 201, 202, 203, 204].contains(code) }
}

public extension Response {
    struct Error {
        public var title: String?
        public var description: String?
        
        public init(title: String? = nil, description: String? = nil) {
            self.title = title
            self.description = description
        }
    }
}
