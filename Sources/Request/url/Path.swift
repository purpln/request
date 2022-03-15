public struct Path: ExpressibleByStringLiteral, PathProtocol {
    public var path: [String]?
    public init(stringLiteral value: String) { path = value.components(separatedBy: "/") }
}

public protocol PathProtocol {
    var path: [String]? { get }
}
extension Array: PathProtocol where Element == String { }
public extension PathProtocol {
    var path: [String]? { self as? [String] }
}
