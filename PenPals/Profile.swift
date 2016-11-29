//
//  Profile.swift
//  PenPals
//
//  Created by Berk Abbasoglu on 12/08/16.
//  Copyright © 2016 Berk Abbasoglu. All rights reserved.
//

import Foundation
import ObjectMapper

class Profile : Mappable {

    var firstName: String = ""
    var gender: String = ""
    var birthdate: String = ""
    var nation: String = ""
    var description: String = "No description"
    var onlineStatus: String = "None"
    var uID: String = ""
    
    required init?(_ map: Map) {
        
    }
    
    init() {}
    
    func mapping(map: Map) {
        firstName <- map["firstName"]
        gender <- map["gender"]
        birthdate <- map["birthdate"]
        nation <- map["nation"]
        description <- map["description"]
        onlineStatus <- map["onlineStatus"]
        uID <- map["id"]
    }
    
    func equals(otherProfile: Profile) -> Bool{
        
        return self.birthdate == otherProfile.birthdate && self.firstName == otherProfile.firstName && self.gender == otherProfile.gender && self.nation == otherProfile.nation
        
        
    }

}