//
//  Message.swift
//  PenPals
//
//  Created by Berk Abbasoglu on 25/08/16.
//  Copyright © 2016 Berk Abbasoglu. All rights reserved.
//

import Foundation
import ObjectMapper

class Message : Mappable {
    
    var content: String = ""
    var messageDate: String = ""
    var senderID: String = ""
    var receiverID: String = ""
    var messageStatus: String = ""
    var firstName: String = ""
    
    required init?(_ map: Map) {
        
    }
    
    init() {}
    
    func mapping(map: Map) {
        content <- map["content"]
        messageDate <- map["messageDate"]
        senderID <- map["senderID"]
        receiverID <- map["receiverID"]
        messageStatus <- map["messageStatus"]
        firstName <- map["firstName"]
    }
}