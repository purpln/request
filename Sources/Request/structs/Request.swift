open class Request {
    open var url: url = .init()
    open var header: [String: String]?
    open var method: String?
    open var body: Body = .none
    open var response: ((Response) -> Void)?
    
    public init() { }
    public init(_ response: @escaping (Response) -> Void) {
        self.response = response
    }
}

extension Request: CustomStringConvertible {
    public var description: String { "<req \(url.description)>" }
}

public extension Request {
    @discardableResult func url(_ value: url) -> Self {
        url = value
        return self
    }
    @discardableResult func header(_ header: Header) -> Self {
        self.header = header.value
        return self
    }
    @discardableResult func method(_ method: Method) -> Self {
        self.method = method.value
        return self
    }
    @discardableResult func body(_ value: Body) -> Self {
        body = value
        return self
    }
    @discardableResult func response(_ closure: @escaping (Response) -> Void) -> Self {
        response = closure
        return self
    }
    
    @discardableResult func scheme(_ scheme: Scheme) -> Self {
        url.scheme(scheme.value)
        return self
    }
    @discardableResult func host(_ host: Host) -> Self {
        url.host(host.value)
        return self
    }
    @discardableResult func port(_ port: Port) -> Self {
        url.port(port.value)
        return self
    }
    @discardableResult func path(_ path: Path) -> Self {
        url.path(path.value)
        return self
    }
    @discardableResult func query(_ query: Query) -> Self {
        url.query(query.value)
        return self
    }
}
