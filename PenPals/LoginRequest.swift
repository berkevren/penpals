//
//  LoginRequest.swift
//  PenPals
//
//  Created by Berk Abbasoglu on 02/08/16.
//  Copyright © 2016 Berk Abbasoglu. All rights reserved.
//

import Foundation

class LoginRequest {

    var username:String
    var password:String
    
    init(un:String, pw:String) {
        self.username = un
        self.password = pw
    }
}