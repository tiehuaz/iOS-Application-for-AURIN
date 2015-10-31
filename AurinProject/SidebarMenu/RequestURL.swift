//
//  RequestURL.swift
//  AurinProject
//
//  Created by tiehuaz on 9/30/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//
import Foundation

/*these functions are used to parse XML format information into normal variables*/

func HTTPsendRequests(request: NSMutableURLRequest,callback: (String, String?) -> Void) {
    
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request,completionHandler :
        {
            data, response, error in
            if error != nil {
                callback("", (error!.localizedDescription) as String)
            } else {
                callback(NSString(data: data!, encoding: NSUTF8StringEncoding) as! String,nil)
            }
    })
    
    task.resume() //Tasks are called with .resume()
    
}

func HTTPGetXML(url: String, callback: (String, String?) -> Void) {
    let request = NSMutableURLRequest(URL: NSURL(string: url)!) //To get the URL of the receiver , var URL: NSURL? is used
    HTTPsendRequests(request, callback: callback)
}