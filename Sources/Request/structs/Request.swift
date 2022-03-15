open class Request {
    open var url: url = .init()
    open var header: [String: String]?
    open var method: String?
    open var body: Body = .none
    open var response: ((Response) -> Void)?
    
    public init() { }
}

extension Request: CustomStringConvertible {
    public var description: String { "<req \(url.description)>" }
}

public extension Request {
    @discardableResult func url(_ value: url) -> Self {
        url = value
        return self
    }
    @discardableResult func header(_ value: HeaderProtocol) -> Self {
        header = value.header
        return self
    }
    @discardableResult func method(_ value: MethodProtocol) -> Self {
        method = value.method
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
    
    @discardableResult func scheme(_ value: SchemeProtocol) -> Self {
        url.scheme(value.scheme)
        return self
    }
    @discardableResult func host(_ value: HostProtocol) -> Self {
        url.host(value.host)
        return self
    }
    @discardableResult func port(_ value: PortProtocol) -> Self {
        url.port(value.port)
        return self
    }
    @discardableResult func path(_ value: PathProtocol) -> Self {
        url.path(value.path)
        return self
    }
    @discardableResult func query(_ value: QueryProtocol) -> Self {
        url.query(value.query)
        return self
    }
}
