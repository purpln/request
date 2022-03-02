public struct Response {
    public var code: Int
    public var error: [Error]?
    public var data: [UInt8]?
    public var headers: [String: Any]
    
    public init(code: Int, error: [Error]? = nil, data: [UInt8]? = nil, headers: [String: Any] = [:]) {
        self.code = code
        self.error = error
        self.data = data
        self.headers = headers
    }
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
