public struct Header: ExpressibleByDictionaryLiteral, HeaderProtocol {
    public var header: [String: String] = [:]
    
    public init(dictionaryLiteral elements: (String, String)...) {
        elements.forEach { key, value in header[key] = value }
    }
}

public protocol HeaderProtocol {
    var header: [String: String]? { get }
}
extension Dictionary: HeaderProtocol { }
public extension HeaderProtocol {
    var header: [String : String]? { self as? [String : String] }
}
