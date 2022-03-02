public struct Protocols: Equatable, ExpressibleByStringLiteral {
    public var value: String
    
    public init(stringLiteral value: String) {
        self.value = value
    }
}

public extension Protocols {
    static var none: Self { "" }
    static var http: Self { "http://" }
    static var https: Self { "https://" }
    static var ws: Self { "ws://" }
    static var wss: Self { "wss://" }
}

extension Protocols: ExpressibleByStringInterpolation {
    public static func custom(_ value: String) -> Self { "\(value.first == ":" ? value : ":" + value)" }
}
