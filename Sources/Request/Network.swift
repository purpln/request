//import Foundation
//
//class Network: NSObject {
//    @discardableResult
//    class func load(req: Request) -> URLSessionDataTask? {
//        let task = URLSession.shared.dataTask(with: req.request) { data, resp, error in
//            guard let resp = resp as? HTTPURLResponse else { return }
//            var response = Response()
//            
//            response.code = resp.statusCode
//            response.data = data
//            response.headers = resp.allHeaderFields
//            
//            DispatchQueue.main.async { if let completion = req.response { completion(response) } }
//        }
//        
//        task.resume()
//        return task
//        
//    }
//}
