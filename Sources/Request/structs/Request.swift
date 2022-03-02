public class Request {
    public var host: Hosts = .none
    public var headers: Headers = .none
    public var `protocol`: Protocols = .none
    public var port: Ports = .none
    public var link: Links = .none
    public var query: Query = .none
    public var method: Methods = .none
    public var body: Body = .none
    
    public var response: ((Response) -> Void)?
    
    public init() { }
}

extension Request: CustomStringConvertible {
    public var url: String { `protocol`.value + host.value + port.value + link.value + query.query }
    public var description: String { "<req \(`protocol`.value)\(host.value)>" }
}

public extension Request {
    @discardableResult func host(_ host: Hosts) -> Self {
        self.host = host
        return self
    }
    @discardableResult func headers(_ headers: Headers) -> Self {
        self.headers = headers
        return self
    }
    @discardableResult func `protocol`(_ protocol: Protocols) -> Self {
        self.protocol = `protocol`
        return self
    }
    @discardableResult func port(_ port: Ports) -> Self {
        self.port = port
        return self
    }
    @discardableResult func link(_ link: Links) -> Self {
        self.link = link
        return self
    }
    @discardableResult func query(_ query: Query) -> Self {
        self.query = query
        return self
    }
    @discardableResult func method(_ method: Methods) -> Self {
        self.method = method
        return self
    }
    @discardableResult func response(_ response: @escaping (Response) -> Void) -> Self {
        self.response = response
        return self
    }
    
    @discardableResult func body(_ body: Body) -> Self {
        self.body = body
        return self
    }
}
