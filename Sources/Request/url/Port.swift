public struct Port: ExpressibleByStringLiteral, ExpressibleByIntegerLiteral {
    public var value: UInt?
    public init(value: UInt? = nil) { self.value = value }
    public init(stringLiteral value: String) { self.value = UInt(value) }
    public init(integerLiteral value: Int) { self.value = UInt(value) }
    public static func custom(_ value: UInt) -> Self { .init(value: value) }
    public static func custom(_ value: Int) -> Self { .init(value: UInt(value)) }
    public static func custom(_ value: String) -> Self { .init(value: UInt(value)) }
}
