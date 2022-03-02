//import Foundation
//
//class Request {
//    var host: String?
//    var headers: [String:String]?
//    var method: Methods = .get
//    var `protocol`: Protocols = .https
//    var port: Ports = .none
//    //var link: Links = .none
//    var query: [String: Any]?
//    //var body: Request.Body?
//    
//    var response: ((Response) -> Void)?
//    //var url: String { `protocol`.value + host + port.value + link.value + (query?.query ?? "") }
//}
//
//extension Request {
//    var request: URLRequest {
//        .init(url: URL(string: "https://google.com")!)
//    }
//}
//
//extension Request {
//    @discardableResult public
//    func host(_ host: String) -> Self {
//        self.host = host
//        return self
//    }
//    @discardableResult public
//    func headers(_ headers: [String:String]?) -> Self {
//        self.headers = headers
//        return self
//    }
//    @discardableResult public
//    func method(_ method: Methods) -> Self {
//        self.method = method
//        return self
//    }
//    @discardableResult public
//    func `protocol`(_ protocol: Protocols) -> Self {
//        self.protocol = `protocol`
//        return self
//    }
//    @discardableResult public
//    func port(_ port: Ports) -> Self {
//        self.port = port
//        return self
//    }
////    @discardableResult public
////    func link(_ link: Links) -> Self {
////        self.link = link
////        return self
////    }
//    @discardableResult public
//    func query(_ query: [String: Any]) -> Self {
//        self.query = query
//        return self
//    }
////    @discardableResult public
////    func body(_ body: Body?) -> Self {
////        self.body = body
////        return self
////    }
//    @discardableResult public
//    func response(_ response: @escaping (Response) -> Void) -> Self {
//        self.response = response
//        return self
//    }
//    @discardableResult public
//    func load() -> URLSessionDataTask? { Network.load(req: self) }
//}
