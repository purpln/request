public enum Body: Codable, Sendable, Equatable {
    case none
    case bytes([UInt8])
}

public extension Body {
    static func file(bytes: [UInt8], boundary: String) -> Body {
        .bytes(bytes)
    }
}
