public struct Query: ExpressibleByDictionaryLiteral, QueryProtocol {
    public var query: [String: String] = [:]
    
    public init(dictionaryLiteral elements: (String, String)...) {
        elements.forEach { key, value in query[key] = value }
    }
}

public protocol QueryProtocol {
    var query: [String: String]? { get }
}
extension Dictionary: QueryProtocol { }
public extension QueryProtocol {
    var query: [String : String]? { self as? [String : String] }
}
