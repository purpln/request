public struct Response: Sendable {
    public var status: Status
    public var headers: Headers
    public var body: Body
}

public extension Response {
    var bytes: [UInt8]? {
        guard case .bytes(let bytes) = body else { return nil }
        return bytes
    }
    
    var string: String? { bytes?.string }
}

extension Array where Element == UInt8 {
    var string: String {
        var string = String()
        string.unicodeScalars.append(contentsOf: map { UnicodeScalar($0) })
        return string
    }
}
