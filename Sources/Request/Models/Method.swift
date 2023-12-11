public enum Method: String, Codable, Sendable, Equatable {
    case get = "GET"
    case post = "POST"
    case head = "HEAD"
    case put = "PUT"
    case delete = "DELETE"
    case connect = "CONNECT"
    case options = "OPTIONS"
    case trace = "TRACE"
}

extension Method: CustomStringConvertible {
    public var description: String { rawValue }
}
