public struct Port: ExpressibleByStringLiteral, ExpressibleByIntegerLiteral, PortProtocol {
    public var port: UInt?
    public init(stringLiteral value: String) { port = UInt(value) }
    public init(integerLiteral value: Int) { port = UInt(value) }
}

public protocol PortProtocol {
    var port: UInt? { get }
}
extension Int: PortProtocol { }
extension UInt: PortProtocol { }
extension String: PortProtocol { }
public extension PortProtocol {
    var port: UInt? {
        if let value = self as? String { return UInt(value) }
        if let value = self as? Int { return UInt(value) }
        if let value = self as? UInt { return value }
        return nil
    }
}
