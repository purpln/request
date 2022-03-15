public struct Scheme: ExpressibleByStringLiteral {
    public var value: String
    public init(value: String = "") { self.value = value }
    public init(stringLiteral value: String = "") { self.value = value }
    public static func custom(_ value: String) -> Self { .init(value: value) }
}
