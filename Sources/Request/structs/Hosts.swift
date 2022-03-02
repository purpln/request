public struct Hosts: Equatable, ExpressibleByStringLiteral {
    public var value: String
    
    public init(value: String = "") {
        self.value = value
    }
    
    public init(stringLiteral value: String) {
        self.value = value.first == "/" ? value : "/" + value
    }
}

public extension Hosts {
    static var none: Self { "" }
}

extension Hosts: ExpressibleByStringInterpolation {
    public static func custom(_ value: String) -> Self { "\(value)" }
}
