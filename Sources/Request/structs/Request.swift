public struct Request {
    public var host: Hosts = .none
    public var headers: Headers = .none
    public var `protocol`: Protocols = .none
    public var port: Ports = .none
    public var link: Links = .none
    public var query: Query = .none
    public var method: Methods = .none
    public var body: Body = .none
    
    var response: ((Response) -> Void)?
}

extension Request: CustomStringConvertible {
    public var url: String { `protocol`.value + host.value + port.value + link.value + query.query }
    public var description: String { "<req \(`protocol`.value)\(host.value)>" }
}

extension Request {
    @discardableResult public mutating
    func host(_ host: Hosts) -> Self {
        self.host = host
        return self
    }
    @discardableResult public mutating
    func headers(_ headers: Headers) -> Self {
        self.headers = headers
        return self
    }
    @discardableResult public mutating
    func `protocol`(_ protocol: Protocols) -> Self {
        self.protocol = `protocol`
        return self
    }
    @discardableResult public mutating
    func port(_ port: Ports) -> Self {
        self.port = port
        return self
    }
    @discardableResult public mutating
    func link(_ link: Links) -> Self {
        self.link = link
        return self
    }
    @discardableResult public mutating
    func query(_ query: Query) -> Self {
        self.query = query
        return self
    }
    @discardableResult public mutating
    func method(_ method: Methods) -> Self {
        self.method = method
        return self
    }
    @discardableResult public mutating
    func response(_ response: @escaping (Response) -> Void) -> Self {
        self.response = response
        return self
    }
    
    @discardableResult public mutating
    func body(_ body: Body) -> Self {
        self.body = body
        return self
    }
}
