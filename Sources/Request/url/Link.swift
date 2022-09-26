public struct Link: OptionSetAssociated {
    public typealias RawValue = UInt8
    
    public let rawValue: RawValue
    public var store: [RawValue: Any] = [:]
    
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
}

extension Link {
    public static var scheme: Self { Self(rawValue: 1 << 0) }
    public static var login: Self { Self(rawValue: 1 << 1) }
    public static var password: Self { Self(rawValue: 1 << 2) }
    public static var host: Self { Self(rawValue: 1 << 3) }
    public static var port: Self { Self(rawValue: 1 << 4) }
    public static var path: Self { Self(rawValue: 1 << 5) }
    public static var query: Self { Self(rawValue: 1 << 6) }
    public static var fragment: Self { Self(rawValue: 1 << 7) }
    
    public static func scheme(_ value: String) -> Self {
        Self(.scheme, value: value)
    }
    public static func login(_ value: String) -> Self {
        Self(.login, value: value)
    }
    public static func password(_ value: String) -> Self {
        Self(.password, value: value)
    }
    public static func host(_ value: String) -> Self {
        Self(.host, value: value)
    }
    public static func port(_ value: UInt16) -> Self {
        Self(.port, value: value)
    }
    public static func path(_ value: [String]) -> Self {
        Self(.path, value: value)
    }
    public static func query(_ value: [String: String]) -> Self {
        Self(.query, value: value)
    }
    public static func fragment(_ value: String) -> Self {
        Self(.fragment, value: value)
    }
}

extension Link {
    public var scheme: String? {
        getValue(for: .scheme) ?? ( contains(.scheme) ? String() : nil )
    }
    public var login: String? {
        getValue(for: .login) ?? ( contains(.login) ? String() : nil )
    }
    public var password: String? {
        getValue(for: .password) ?? ( contains(.password) ? String() : nil )
    }
    public var host: String? {
        getValue(for: .host) ?? ( contains(.host) ? String() : nil )
    }
    public var port: String? {
        getValue(for: .port) ?? ( contains(.port) ? String() : nil )
    }
    public var path: [String]? {
        getValue(for: .path) ?? ( contains(.path) ? [String]() : nil )
    }
    public var query: [String: String]? {
        getValue(for: .query) ?? ( contains(.query) ? [String: String]() : nil )
    }
    public var fragment: String? {
        getValue(for: .fragment) ?? ( contains(.fragment) ? String() : nil )
    }
}
