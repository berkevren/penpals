//
//  AuthenticationServices.swift
//  PenPals
//
//  Created by Berk Abbasoglu on 12/08/16.
//  Copyright © 2016 Berk Abbasoglu. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

private let _authService = AuthenticationService()

class AuthenticationService {
    
    var current: Account?
    var matchedProfile: Profile?
    var inbox: Inbox?

    
    func register (account: Account, completionHandler: (Bool) -> ()) -> (){
    
        let post = RequestHelper.postRequest("account/addAccount", mappable: account)
        
        Alamofire.request(post)
            .responseJSON{ response in
                completionHandler(true)
        }
    }
    
    func login (username: String, password: String, completionHandler: (Bool) -> ()) -> (){
        
        // request account with given username and password
        let get = RequestHelper.getRequest("account/signIn?email=" + username + "&password=" + password)
        
        // get response from server
        Alamofire.request(get)
            .responseJSON{ response in
                if let JSON = response.result.value { // the response
                    if let loginResponse = Mapper<LoginResponse>().map(JSON) {
                        
                        // status = 0 -> success, status = 1 -> fail
                        // calls login method from LoginViewController
                        if loginResponse.status == 0 {
                            self.current = loginResponse.data
                            self.current?.profile.description = (loginResponse.data?.profile.description)!
                            //print(self.current?.profile.description)
                            completionHandler(true)
                            
                        } else {
                            
                            completionHandler(false)
                        
                        }
                    }
                }
        }
    }
    
    func match(nation: String, gender: String, completionHandler: (Bool) -> ()) -> () {
        
        let get = RequestHelper.getRequest("profile/matchPeople?nation=" + nation + "&gender=" + gender)
        
        Alamofire.request(get)
            .responseJSON { response in
                if let JSON = response.result.value {
                    if let matchResponse = Mapper<MatchResponse>().map(JSON) {
                        
                        if matchResponse.status == 0 {
                            
                            self.matchedProfile = matchResponse.data
                            completionHandler(true)
                            
                        } else {
                            
                            completionHandler(false)
                            
                        }
                        
                    }
                }
        }
    }
    
    func updateDescription(desc: String, completionHandler: (Bool) -> ()) -> () {
        
        // request account with given username and password
        let get = RequestHelper.getRequest(("account/changeDescription?email=" + (self.current?.email)! + "&description=" + desc).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        
        // get response from server
        Alamofire.request(get)
            .responseJSON{ response in
                if let JSON = response.result.value { // the response
                    if let genericResponse = Mapper<GenericResponse>().map(JSON) {
                        
                        // status = 0 -> success, status = 1 -> fail
                        if genericResponse.status == 0 {
                            completionHandler(true)
                            
                        } else {
                            
                            completionHandler(false)
                            
                        }
                    }
                }
        }
    }
    
    func logOut(email: String, completionHandler: (Bool) -> ()) -> () {
        
        // request account with given email
        let get = RequestHelper.getRequest("account/signOut?email=" + (self.current?.email)!)
        
        // get response from server
        Alamofire.request(get)
            .responseJSON { response in
                if let JSON = response.result.value {
                    if let genericResponse = Mapper<GenericResponse>().map(JSON) {
                        
                        // status = 0 -> success, status = 1 -> fail
                        if genericResponse.status == 0 {
                            completionHandler(true)
                        }
                        else {
                            completionHandler(false)
                        }
                    }
                }
        }
    }
    
    func sendMessage(message: Message, completionHandler: (Bool) -> ()) -> () {
        
        let post = RequestHelper.postRequest("message/sendMessage", mappable: message)
        
        Alamofire.request(post)
            .responseJSON { response in
                completionHandler(true)
        }
        
    }
    
    func listMessages(completionHandler: (Bool) -> ()) -> () {
        
        let get = RequestHelper.getRequest("message/listMessages?receiver=" + current!.uID)
        
        Alamofire.request(get)
            .responseJSON { response in
                if let JSON = response.result.value {
                    if let inboxResponse = Mapper<InboxResponse>().map(JSON) {
                        
                        if inboxResponse.status == 0 {
                            
                            print("shows inbox with id " + self.current!.uID)
                            self.inbox = inboxResponse.data
                            print(self.inbox?.messageList[0].firstName)
                            completionHandler(true)
                        }
                        else {
                            completionHandler(false)
                        }
                    }
                }
        }
        
    }
    
    class var sharedInstance : AuthenticationService {
        return _authService
    }
    
}