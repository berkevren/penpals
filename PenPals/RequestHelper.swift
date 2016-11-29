//
//  RequestHelper.swift
//  PenPals
//
//  Created by Berk Abbasoglu on 12/08/16.
//  Copyright © 2016 Berk Abbasoglu. All rights reserved.
//

import Foundation
import ObjectMapper

class RequestHelper{
    
    class func postRequest<T:Mappable>(url:String, mappable:T) -> NSMutableURLRequest {
        
        let JSONData = Mapper().toJSONString(mappable, prettyPrint: false)
        let post = NSMutableURLRequest(URL: NSURL(string: "http://192.168.2.119:8081/" + url)!)
        post.setValue("application/json", forHTTPHeaderField: "Content-Type")
        post.HTTPMethod = "POST"
        post.HTTPBody = JSONData?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        // add authentication headers if there are any
        //addAuthorization(post)
        
        return post
    }
    
    class func postRequest(url:String) -> NSMutableURLRequest{
        
        let post = NSMutableURLRequest(URL: NSURL(string: "http://192.168.2.119:8081/" + url)!)
        post.setValue("application/json", forHTTPHeaderField: "Content-Type")
        post.HTTPMethod = "POST"
        
        // add authentication headers if there are any
        //addAuthorization(post)
        
        return post
    }
    
    
    class func getRequest(url:String) -> NSMutableURLRequest{
        let get = NSMutableURLRequest(URL: NSURL(string: "http://192.168.2.119:8081/" + url)!)
        get.HTTPMethod = "GET"
        
        // add authentication headers if there are any
        //addAuthorization(get)
        
        return get
    }
    
    private class func addAuthorization(request:NSMutableURLRequest){
        /*if let token = NSUserDefaults.standardUserDefaults().valueForKey(Constants.TOKEN) as? String{
         request.setValue(token, forHTTPHeaderField: "X-TOKEN")
         
         if let tokenSecret = NSUserDefaults.standardUserDefaults().valueForKey(Constants.TOKEN_SECRET) as? String{
         request.setValue(tokenSecret, forHTTPHeaderField: "X-TOKEN-SECRET")
         }
         }*/
    }
}