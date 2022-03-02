public struct Query: ExpressibleByDictionaryLiteral {
    public var value: [AnyHashable: Any]
    
    public init(value: [AnyHashable: Any] = [:]) {
        self.value = value
    }
    
    public init(dictionaryLiteral elements: (AnyHashable, Any)...) {
        self.init()
        elements.forEach { tuple in update(tuple) }
    }
    
    mutating func update(_ tuple: (key: AnyHashable, value: Any)) {
        value[tuple.key] = tuple.value
    }
}

public extension Query {
    static var none: Self { [:] }
}

extension Query {
    public static func custom(_ value: [AnyHashable: Any]) -> Self { .init(value: value) }
}
