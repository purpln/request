public struct Scheme: ExpressibleByStringLiteral, SchemeProtocol {
    public var scheme: String?
    public init(stringLiteral value: String) { scheme = value }
}

public protocol SchemeProtocol {
    var scheme: String? { get }
}
extension String: SchemeProtocol { }
public extension SchemeProtocol {
    var scheme: String? { self as? String }
}
