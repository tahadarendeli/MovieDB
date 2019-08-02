//
//  MovieEntity.swift
//  TMDB
//
//  Created by Taha Darendeli on 31.07.2019.
//  Copyright © 2019 Taha Darendeli. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MovieEntity: ShowEntity {
    
    var video = false
    var title = ""
    var original_title = ""
    var adult = false
    var release_date = ""
    
    class func getList(endPoint: String, extensionParameters: String = "", result:@escaping ([MovieEntity]?)->()){
        
        var list = [MovieEntity]()
        let urlString = Utility.serviceUrl() + "movie/\(endPoint)" + Utility.getApiKey() + "&\(extensionParameters)"
        
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
    
    class func parseJson(json : JSON) -> MovieEntity{
        let ent = MovieEntity()
        
        ent.vote_count = json["vote_count"].intValue
        ent.id = json["id"].intValue
        ent.video = json["video"].boolValue
        ent.vote_average = json["vote_average"].doubleValue
        ent.title = json["title"].stringValue
        ent.popularity = json["popularity"].doubleValue
        ent.poster_path = Utility.imageUrl() + json["poster_path"].stringValue
        ent.original_language = json["original_language"].stringValue
        ent.original_title = json["original_title"].stringValue
        for genre in json["genre_ids"].arrayValue {
            ent.genre_ids.append(genre.stringValue)
        }
        ent.backdrop_path = Utility.imageUrl() + json["backdrop_path"].stringValue
        ent.adult = json["adult"].boolValue
        ent.overview = json["overview"].stringValue
        ent.release_date = json["release_date"].stringValue
        
        return ent
    }
}
