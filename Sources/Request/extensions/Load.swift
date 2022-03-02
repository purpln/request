import Foundation

extension Request {
    public var request: URLRequest? {
        var url = url
        
        if let new = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
            url = new.replacingOccurrences(of: "+", with: "%2B")
        }
        
        guard let link = URL(string: url) else { return nil }
        var request = URLRequest(url: link)
        
        if method != .none { request.httpMethod = method.value }
        headers.value.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key)}
        
        guard body != .none, method != .get, method != .none else { return request }
        
        if body.boundary == "" {
            request.httpBody = .init(body.data)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } else {
            request.httpBody = .init(body.data)
            request.addValue("multipart/form-data; boundary=\(body.boundary)", forHTTPHeaderField: "Content-Type")
            request.addValue(String(body.data.count), forHTTPHeaderField: "Content-Length")
        }
        
        return request
    }
    
    @discardableResult public func load() -> URLSessionDataTask? { Network.load(req: self) }
}
