public struct Method: Equatable, ExpressibleByStringLiteral, MethodProtocol {
    public var method: String?
    public init(stringLiteral value: String) { method = value }
}

public protocol MethodProtocol {
    var method: String? { get }
}
extension String: MethodProtocol { }
public extension MethodProtocol {
    var method: String? { self as? String }
}
