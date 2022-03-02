public struct Ports: Equatable, ExpressibleByStringLiteral, ExpressibleByIntegerLiteral {
    public var value: String
    
    public init(value: String = "") {
        self.value = value
    }
    
    public init(stringLiteral value: String) {
        self.value = value.first == ":" ? value : ":" + value
    }
    
    public init(integerLiteral value: Int) {
        self = .custom(String(value))
    }
}

public extension Ports {
    static var none: Self { "" }
    static var regular: Self { ":80" }
    static var secured: Self { ":443" }
    static var dev: Self { ":8080" }
}

extension Ports: ExpressibleByStringInterpolation {
    public static func custom(_ value: String) -> Self { "\(value)" }
}
