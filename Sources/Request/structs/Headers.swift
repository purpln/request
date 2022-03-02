public struct Headers: ExpressibleByDictionaryLiteral {
    public var value: [String: String]
    
    public init(dictionaryLiteral elements: (String, String)...) {
        self.init()
        elements.forEach { tuple in update(tuple) }
    }
    
    public init(value: [String: String] = [:]) {
        self.value = value
    }
    
    mutating func update(_ tuple: (key: String, value: String)) {
        value[tuple.key] = tuple.value
    }
}

public extension Headers {
    static var none: Self { [:] }
}
