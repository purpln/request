import Foundation

class Network: NSObject {
    @discardableResult
    class func load(req: Request) -> URLSessionDataTask? {
        guard let request = req.request else { return nil }
        let task = URLSession.shared.dataTask(with: request) { data, resp, error in
            guard let resp = resp as? HTTPURLResponse else { return }
            var response = Response(code: resp.statusCode)
            if let data = data { response.data = [UInt8](data) }
            response.headers = resp.allHeaderFields
            
            DispatchQueue.main.async { if let completion = req.response { completion(response) } }
        }
        
        task.resume()
        return task
        
    }
}
