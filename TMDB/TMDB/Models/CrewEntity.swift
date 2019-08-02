//
//  CrewEntity.swift
//  TMDB
//
//  Created by Taha Darendeli on 31.07.2019.
//  Copyright © 2019 Taha Darendeli. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CrewEntity: CreditsEntity {
    
    var department = ""
    
    class func parseJson(json : JSON) -> CrewEntity{
        let ent = CrewEntity()
        
        ent.credit_id = json["credit_id"].stringValue
        ent.department = json["department"].stringValue
        ent.gender = json["gender"].intValue
        ent.id = json["id"].intValue
        ent.job = json["job"].stringValue
        ent.name = json["name"].stringValue
        ent.profile_path = Utility.imageUrl() + json["profile_path"].stringValue
        
        return ent
    }
}
