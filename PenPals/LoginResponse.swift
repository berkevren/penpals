//
//  LoginResponse.swift
//  PenPals
//
//  Created by Berk Abbasoglu on 17/08/16.
//  Copyright © 2016 Berk Abbasoglu. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginResponse : Mappable {

    var status: Int = -1
    var message: String?
    var data: Account?
    
    
    required init?(_ map: Map) {
        
    }
    
    init(){}
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
    }

}