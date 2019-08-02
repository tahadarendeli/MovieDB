//
//  TVEntity.swift
//  TMDB
//
//  Created by Taha Darendeli on 1.08.2019.
//  Copyright © 2019 Taha Darendeli. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TVEntity: ShowEntity {
    
    var name = ""
    var original_name = ""
    var first_air_date = ""
    
    class func getList(endPoint: String, extensionParameters: String = "", result:@escaping ([TVEntity]?)->()){
        
        var list = [TVEntity]()
        let urlString = Utility.serviceUrl() + "tv/\(endPoint)" + Utility.getApiKey() + "&\(extensionParameters)"
        
        Alamofire.request(urlString).responseJSON { response in
            
            if let response = response.result.value {
                let json = JSON(response)
                print("JSON: \(json)") // json response
                
                for i in 0..<json["results"].count {
                    let item = json["results"][i]
                    list.append(parseJson(json: item))
                }
                result(list)
                
                return
            }
            result(nil)
        }
    }
    
    class func parseJson(json : JSON) -> TVEntity{
        let ent = TVEntity()
        
        ent.vote_count = json["vote_count"].intValue
        ent.id = json["id"].intValue
        ent.vote_average = json["vote_average"].doubleValue
        ent.name = json["name"].stringValue
        ent.popularity = json["popularity"].doubleValue
        ent.poster_path = Utility.imageUrl() + json["poster_path"].stringValue
        ent.original_language = json["original_language"].stringValue
        ent.original_name = json["original_name"].stringValue
        for genre in json["genre_ids"].arrayValue {
            ent.genre_ids.append(genre.stringValue)
        }
        ent.backdrop_path = Utility.imageUrl() + json["backdrop_path"].stringValue
        ent.overview = json["overview"].stringValue
        ent.first_air_date = json["first_air_date"].stringValue
        
        return ent
    }
}
