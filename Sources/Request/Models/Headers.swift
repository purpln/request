public struct Headers: Sendable {
    public var headers: [(key: String, value: String)]
    
    public init(dictionary: [String: String]) {
        self.headers = dictionary.reduce(into: [(String, String)]()) { array, element in
            array.append((String(describing: element.key), String(describing: element.value)))
        }
    }
    
    public init(headers: [(String, String)] = []) {
        self.headers = headers
    }
}

public extension Headers {
    static var none: Self { Headers() }
}

public extension Headers {
    mutating func append(key: String, value: String) {
        headers.append((key: key, value: value))
    }
}
