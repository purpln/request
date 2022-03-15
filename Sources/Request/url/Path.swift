public struct Path: ExpressibleByStringLiteral {
    public var value: [String]
    public init(value: [String] = []) { self.value = value }
    public init(stringLiteral value: String) { self.value = value.components(separatedBy: "/") }
    public static func custom(_ value: String) -> Self { .init(value: value.components(separatedBy: "/")) }
    public static func custom(_ value: [String]) -> Self { .init(value: value) }
}
