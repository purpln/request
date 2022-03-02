public struct Methods: Equatable, ExpressibleByStringLiteral {
    public var value: String
    
    public init(value: String = "") {
        self.value = value
    }
    
    public init(stringLiteral value: String) {
        self.value = value
    }
}

public extension Methods {
    static var none: Self { "" }
    static var get: Self { "GET" }
    static var post: Self { "POST" }
    static var head: Self { "HEAD" }
    static var put: Self { "PUT" }
    static var del: Self { "DELETE" }
}

extension Methods: ExpressibleByStringInterpolation {
    public static func custom(_ value: String) -> Self { "\(value)" }
}
