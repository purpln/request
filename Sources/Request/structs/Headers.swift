public struct Headers: ExpressibleByDictionaryLiteral {
    public var value: [String: String]
    
    public init(value: [String: String] = [:]) {
        self.value = value
    }
    
    public init(dictionaryLiteral elements: (String, String)...) {
        self.init()
        elements.forEach { tuple in update(tuple) }
    }
    
    mutating func update(_ tuple: (key: String, value: String)) {
        value[tuple.key] = tuple.value
    }
}

public extension Headers {
    static var none: Self { [:] }
}

extension Headers {
    public static func custom(_ value: [String: String]) -> Self { .init(value: value) }
}
