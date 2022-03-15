public struct Host: Equatable, ExpressibleByStringLiteral, HostProtocol {
    public var host: String?
    public init(stringLiteral value: String) { host = value }
}

public protocol HostProtocol {
    var host: String? { get }
}
extension String: HostProtocol { }
public extension HostProtocol {
    var host: String? { self as? String }
}
