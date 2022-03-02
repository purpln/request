public struct Query: ExpressibleByDictionaryLiteral {
    public var value: [String: Any]
    
    public init(value: [String: Any] = [:]) {
        self.value = value
    }
    
    public init(dictionaryLiteral elements: (String, Any)...) {
        self.init()
        elements.forEach { tuple in update(tuple) }
    }
    
    mutating func update(_ tuple: (key: String, value: Any)) {
        value[tuple.key] = tuple.value
    }
    
    public var query: String {
        var string = "?"
        value.forEach { key, value in
            string += "\(key)=\(value)&"
        }
        return String(string.dropLast())
    }
}

public extension Query {
    static var none: Self { [:] }
}

extension Query {
    public static func custom(_ value: [String: Any]) -> Self { .init(value: value) }
}
