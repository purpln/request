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


public extension url {
    init?(string: String) {
        var components: Set<Component> = []
        var string = string
        let fragments = string.components(separatedBy: "#")
        if fragments.count == 2, let fragment = fragments.last, let clean = fragments.first {
            components.insert(.fragment(fragment))
            string = clean
        }
        let query = string.components(separatedBy: "?")
        if query.count == 2, let items = query.last?.components(separatedBy: "&").reduce(into: [String: String](), {
            let values = $1.components(separatedBy: "=")
            if values.count == 2, let key = values.first, let value = values.last {
                $0[key] = value
            }
        }), let clean = query.first {
            components.insert(.query(items))
            string = clean
        }
        let authorization = string.components(separatedBy: "@")
        if authorization.count == 2, let items = authorization.first?.components(separatedBy: "://"),
           items.count == 2, let scheme = items.first, let values = items.last?.components(separatedBy: ":"),
           let clean = authorization.last?.components(separatedBy: "/"), let address = clean.first?.components(separatedBy: ":") {
            components.insert(.scheme(scheme))
            if values.count == 2, let login = values.first, let password = values.last {
                components.insert(.login(login))
                components.insert(.password(password))
            } else if values.count == 1, let value = values.first {
                if value.contains(":") {
                    let password = value.replacingOccurrences(of: ":", with: "")
                    components.insert(.password(password))
                } else {
                    components.insert(.login(value))
                }
            } else { return nil }
            if address.count == 2, let host = address.first, let value = address.last {
                components.insert(.host(host))
                if let port = UInt(String(value)) {
                    components.insert(.port(port))
                }
            } else if address.count == 1, let host = address.first {
                components.insert(.host(host))
            } else { return nil }
            var array = clean
            if array.count > 0 {
                array.removeFirst()
                components.insert(.path(array))
            }
        } else if let items = authorization.first?.components(separatedBy: ":") {
            
            if items.count == 3, let scheme = items[safe: 0],
               let host = items[safe: 1]?.replacingOccurrences(of: "//", with: ""), let values = items[safe: 2]?.components(separatedBy: "/") {
                components.insert(.scheme(scheme))
                components.insert(.host(host))
                var array = values
                if array.count > 0 {
                    let value = array.removeFirst()
                    if array != [] {
                        components.insert(.path(array))
                    }
                    if let port = UInt(String(value)) {
                        components.insert(.port(port))
                    }
                }
            } else if items.count == 2, let scheme = items.first, let address = items.last {
                components.insert(.scheme(scheme))
                if Array(address)[safe: 0] == "/", Array(address)[safe: 1] == "/" {
                    var array = address.replacingOccurrences(of: "//", with: "").components(separatedBy: "/")
                    if array != [] {
                        let host = array.removeFirst()
                        components.insert(.host(host))
                        if array != [] {
                            components.insert(.path(array))
                        }
                    }
                } else {
                    let array = address.components(separatedBy: "/")
                    if array != [] {
                        components.insert(.path(array))
                    }
                }
            } else { return nil }
        } else { return nil }
        self.init(components)
    }
}
