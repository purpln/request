public struct Headers: ExpressibleByDictionaryLiteral {
    var value: [String: String]
    
    mutating func updateCount(_ n: Int, for element: String) {
        print(n, element)
    }
    
    public init(value: [String: String] = [:]) {
        self.value = value
    }
    
    public init(dictionaryLiteral elements: (String, Int)...) {
        self.init()
        elements.forEach { (element, count) in
            updateCount(count, for: element)
        }
    }
}

public extension Headers {
    static var none: Self { [:] }
}
