import Foundation

/*these functions are used ot send HTTP request and parse returned JSON data*/

func JSONParseDict(jsonString:String) -> Dictionary<String, AnyObject> {
    
    if let data: NSData = jsonString.dataUsingEncoding(
        NSUTF8StringEncoding){
            
            do{
                if let jsonObj = try NSJSONSerialization.JSONObjectWithData(
                    data,
                    options: NSJSONReadingOptions(rawValue: 0)) as? Dictionary<String, AnyObject>{
                        return jsonObj
                }
            }catch{
                print("Error")
            }
    }
    return [String: AnyObject]()
}

func HTTPsendRequest(request: NSMutableURLRequest,
    callback: (String, String?) -> Void) {
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(
            request, completionHandler :
            {
                data, response, error in
                if error != nil {
                    callback("", (error!.localizedDescription) as String)
                } else {
                    callback(
                        NSString(data: data!, encoding: NSUTF8StringEncoding) as! String,
                        nil
                    )
                }
        })
        
        task.resume()
        
}

func HTTPGetJSON(
    url: String,
    callback: (Dictionary<String, AnyObject>, String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        HTTPsendRequest(request) {
            (data: String, error: String?) -> Void in
            if error != nil {
                callback(Dictionary<String, AnyObject>(), error)
            } else {
                let jsonObj = JSONParseDict(data)
                callback(jsonObj, nil)
            }
        }
}

