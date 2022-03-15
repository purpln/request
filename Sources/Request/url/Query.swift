public struct Query: ExpressibleByDictionaryLiteral {
    public var value: [String: String]
    public init(value: [String: String] = [:]) { self.value = value }
    public init(dictionaryLiteral elements: (String, String)...) {
        self.init()
        elements.forEach { key, value in self.value[key] = value }
    }
    public static func custom(_ value: [String: String]) -> Self { .init(value: value) }
}
