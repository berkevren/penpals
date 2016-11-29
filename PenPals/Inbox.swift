//
//  Inbox.swift
//  PenPals
//
//  Created by Berk Abbasoglu on 25/08/16.
//  Copyright © 2016 Berk Abbasoglu. All rights reserved.
//

import Foundation
import ObjectMapper

class Inbox : Mappable {
    
    var messageList = [Message]()
    
    required init?(_ map: Map) {
        
    }
    
    init(){}
    
    func mapping(map: Map) {
        
        messageList <- map["messageList"]
        
    }
    
}