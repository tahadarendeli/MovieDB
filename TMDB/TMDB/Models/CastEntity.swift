//
//  CastEntity.swift
//  TMDB
//
//  Created by Taha Darendeli on 31.07.2019.
//  Copyright © 2019 Taha Darendeli. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CastEntity: CreditsEntity {
    var cast_id = 0
    var character = ""
    var order = 0
    
    class func parseJson(json : JSON) -> CastEntity {
        let ent = CastEntity()
        
        ent.credit_id = json["credit_id"].stringValue
        ent.gender = json["gender"].intValue
        ent.id = json["id"].intValue
        ent.job = json["job"].stringValue
        ent.name = json["name"].stringValue
        ent.profile_path = Utility.imageUrl() + json["profile_path"].stringValue
        ent.cast_id = json["cast_id"].intValue
        ent.character = json["character"].stringValue
        ent.order = json["order"].intValue
        
        return ent
    }
}
