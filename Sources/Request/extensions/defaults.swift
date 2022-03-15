public extension Method {
    static var get: Self { "GET" }
    static var head: Self { "HEAD" }
    static var post: Self { "POST" }
    static var put: Self { "PUT" }
    static var delete: Self { "DELETE" }
    static var connect: Self { "CONNECT" }
    static var options: Self { "OPTIONS" }
    static var trace: Self { "TRACE" }
}

public extension Header {
    
}

public extension Scheme {
    static var http: Self { "http" }
    static var https: Self { "https" }
    static var ws: Self { "ws" }
    static var wss: Self { "wss" }
}

public extension Host {
    
}

public extension Port {
    static var regular: Self { "80" }
    static var secured: Self { "443" }
    static var dev: Self { "8080" }
}

public extension Path {
    
}

public extension Query {
    
}
