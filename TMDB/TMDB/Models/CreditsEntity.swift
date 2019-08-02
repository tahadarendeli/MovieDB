//
//  CreditsEntity.swift
//  TMDB
//
//  Created by Taha Darendeli on 31.07.2019.
//  Copyright © 2019 Taha Darendeli. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CreditsEntity: NSObject {
    var credit_id = ""
    var gender = 0
    var id = 0
    var job = ""
    var name = ""
    var profile_path = ""
    var credits : [CreditsEntity] = []
    
    class func getList(type: String, id: String, result:@escaping (CreditsEntity?)->()){
        
        var item = CreditsEntity()
        var cast : [CastEntity] = []
        var crew : [CrewEntity] = []
        
        let urlString = Utility.serviceUrl() + "\(type)/\(id)/credits" + Utility.getApiKey()
        
        Alamofire.request(urlString).responseJSON { response in
            
            if let response = response.result.value {
                let json = JSON(response)
                print("JSON: \(json)") // json response
                
                for i in 0..<json["cast"].count {
                    let item = json["cast"][i]
                    cast.append(CastEntity.parseJson(json: item))
                }
                
                for i in 0..<json["crew"].count {
                    let item = json["crew"][i]
                    crew.append(CrewEntity.parseJson(json: item))
                }
                
                item.credits = self.adjustList(cast: cast, crew: crew)
                
                result(item)
                
                return
            }
            result(nil)
        }
    }
    
    class func adjustList(cast: [CastEntity], crew: [CrewEntity]) -> [CreditsEntity] {
        var list : [CreditsEntity] = []
        
        list = cast
        
        for member in crew {
            if (member as CreditsEntity).job == "Director" {
                list.insert(member, at: 0)
            } else {
                list.append(member)
            }
        }
        
        return list
    }
}
