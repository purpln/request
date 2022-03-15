public struct url {
    public var components: Set<Component> = []
    public init(_ components: Set<Component> = []) { self.components = components }
    public init(_ components: [Component]) { self.components = Set(components) }
    public init(_ components: Component...) { self.components = Set(components) }
}

public extension url {
    var value: String? {
        if let scheme = scheme, scheme != "" {
            if let host = host, host != "" {
                var result: String = ""
                if let login = login, let password = password, login != "", password != "" {
                    result = login + ":" + password + "@"
                } else if let login = login, login != "" {
                    result = login + "@"
                } else if let password = password, password != "" {
                    result = ":" + password + "@"
                }
                result = result + host
                if let port = port {
                    result = result + ":" + String(port)
                }
                result = scheme + "://" + result
                if let path = path?.filter({$0.isEmpty == false}), path != [] {
                    result += "/" + path.joined(separator: "/")
                }
                if let query = query, query != [:] {
                    result += "?"
                    query.forEach { key, value in
                        result += "\(key)=\(value)&"
                    }
                    result = String(result.dropLast())
                }
                if let fragment = fragment, fragment != "" {
                    result = result + "#" + fragment
                }
                return result
            } else if let path = path?.filter({$0.isEmpty == false}), path != [] {
                return scheme + ":" + path.joined(separator: "/")
            } else { return nil }
        } else { return nil }
    }
    
    var scheme: String? { components.first(where: { $0.scheme != nil })?.scheme }
    var login: String? { components.first(where: { $0.login != nil })?.login }
    var password: String? { components.first(where: { $0.password != nil })?.password }
    var host: String? { components.first(where: { $0.host != nil })?.host }
    var port: UInt? { components.first(where: { $0.port != nil })?.port }
    var path: [String]? { components.first(where: { $0.path != nil })?.path }
    var query: [String: String]? { components.first(where: { $0.query != nil })?.query }
    var fragment: String? { components.first(where: { $0.fragment != nil })?.fragment }
}

extension url: CustomStringConvertible {
    public var description: String {
        if let scheme = scheme, scheme != "", let host = host, host != "", let path = path?.filter({$0.isEmpty == false}), path != [] {
            return scheme + "://" + host + "/" + path.joined(separator: "/")
        } else if let scheme = scheme, scheme != "", let host = host, host != "" {
            return scheme + "://" + host
        } else if let host = host, host != "", let path = path?.filter({$0.isEmpty == false}), path != [] {
            return host + "/" + path.joined(separator: "/")
        } else { return "url: nil" }
    }
    public static var none: Self { .init() }
}

public enum Component: Hashable {
    case scheme(String)
    case login(String)
    case password(String)
    case host(String)
    case port(UInt)
    case path([String])
    case query([String: String])
    case fragment(String)
    
    public static func == (lhs: Component, rhs: Component) -> Bool {
        switch (lhs, rhs) {
        case (.scheme, .scheme),
            (.login, .login),
            (.password, .password),
            (.host, .host),
            (.port, .port),
            (.path, .path),
            (.query, .query),
            (.fragment, .fragment): return true
        default: return false
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .scheme(let value): hasher.combine(value)
        case .login(let value): hasher.combine(value)
        case .password(let value): hasher.combine(value)
        case .host(let value): hasher.combine(value)
        case .port(let value): hasher.combine(value)
        case .path(let value): hasher.combine(value)
        case .query(let value): hasher.combine(value)
        case .fragment(let value): hasher.combine(value)
        }
    }
    
    public var key: String {
        switch self {
        case .scheme: return "scheme"
        case .login: return "login"
        case .password: return "password"
        case .host: return "host"
        case .port: return "port"
        case .path: return "path"
        case .query: return "query"
        case .fragment: return "fragment"
        }
    }
    
    public var value: Any {
        switch self {
        case .scheme(let value): return value
        case .login(let value): return value
        case .password(let value): return value
        case .host(let value): return value
        case .port(let value): return value
        case .path(let value): return value
        case .query(let value): return value
        case .fragment(let value): return value
        }
    }
    
    public var scheme: String? { key == "scheme" ? value as? String : nil }
    public var login: String? { key == "login" ? value as? String : nil  }
    public var password: String? { key == "password" ? value as? String : nil  }
    public var host: String? { key == "host" ? value as? String : nil  }
    public var port: UInt? { key == "port" ? value as? UInt : nil  }
    public var path: [String]? { key == "path" ? value as? [String] : nil  }
    public var query: [String: String]? { key == "query" ? value as? [String: String] : nil  }
    public var fragment: String? { key == "fragment" ? value as? String : nil  }
}

public extension url {
    @discardableResult mutating
    func scheme(_ value: String?) -> Self {
        if let value = value {
            components.insert(.scheme(value))
        } else if let scheme = scheme {
            components.remove(.scheme(scheme))
        }
        return self
    }
    @discardableResult mutating
    func login(_ value: String?) -> Self {
        if let value = value {
            components.insert(.login(value))
        } else if let login = login {
            components.remove(.login(login))
        }
        return self
    }
    @discardableResult mutating
    func password(_ value: String?) -> Self {
        if let value = value {
            components.insert(.password(value))
        } else if let password = password {
            components.remove(.password(password))
        }
        return self
    }
    @discardableResult mutating
    func host(_ value: String?) -> Self {
        if let value = value {
            components.insert(.host(value))
        } else if let host = host {
            components.remove(.host(host))
        }
        return self
    }
    @discardableResult mutating
    func port(_ value: UInt?) -> Self {
        if let value = value {
            components.insert(.port(value))
        } else if let port = port {
            components.remove(.port(port))
        }
        return self
    }
    @discardableResult mutating
    func path(_ value: [String]?) -> Self {
        if let value = value {
            components.insert(.path(value))
        } else if let path = path {
            components.remove(.path(path))
        }
        return self
    }
    @discardableResult mutating
    func query(_ value: [String:String]?) -> Self {
        if let value = value {
            components.insert(.query(value))
        } else if let query = query {
            components.remove(.query(query))
        }
        return self
    }
    @discardableResult mutating
    func fragment(_ value: String?) -> Self {
        if let value = value {
            components.insert(.fragment(value))
        } else if let fragment = fragment {
            components.remove(.fragment(fragment))
        }
        return self
    }
}
