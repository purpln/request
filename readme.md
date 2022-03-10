```swift
class Upload: Request {
    @discardableResult
    convenience init(_ closure: @escaping (Response) -> Void) {
        self.init()
        host = "feeds.bbci.co.uk"
        link = "sport/rss.xml"
        query = ["edition":"uk"]
        method = .get
        `protocol` = .https
        response = closure
        //body =  Body(data: [UInt8]("text".utf8), file: "text.txt", name: "key", type: "text/plain")
        load()
    }
}

Upload { [weak self] response in
    
}

let request = Request()
request.response { [weak self] response in
    
}
request.host("feeds.bbci.co.uk").link("sport/rss.xml").query(["edition":"uk"]).method(.get).protocol(.https).load()
```
