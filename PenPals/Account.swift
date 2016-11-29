//
//  Account.swift
//  PenPals
//
//  Created by Berk Abbasoglu on 12/08/16.
//  Copyright © 2016 Berk Abbasoglu. All rights reserved.
//

import Foundation
import ObjectMapper


class Account : Mappable {

    var email : String = ""
    var password: String = ""
    var uID: String = ""
    var profile : Profile = Profile()
    
    required init?(_ map: Map) {
        
    }
    
    init(){}
    
    func mapping(map: Map) {
        email <- map["email"]
        password <- map["password"]
        uID <- map["id"]
        profile <- map["profile"]
    }

}
