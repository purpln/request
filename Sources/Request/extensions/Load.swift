import Foundation

extension Request {
    public var request: URLRequest? {
        guard var url = url.value else { return nil }
        
        if let new = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
            url = new.replacingOccurrences(of: "+", with: "%2B")
        }
        
        guard let link = URL(string: url) else { return nil }
        var request = URLRequest(url: link)
        
        if let method = method { request.httpMethod = method }
        header?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key)}
        
        guard body != .none, method != "GET", method != "" else { return request }
        
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
