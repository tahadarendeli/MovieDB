//
//  MovieDetailEntity.swift
//  TMDB
//
//  Created by Taha Darendeli on 31.07.2019.
//  Copyright © 2019 Taha Darendeli. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MovieDetailEntity: ShowDetailEntity {
    
    var adult = false
    var backdrop_path = ""
    var budget = 0
    var genres : [String] = []
    var homepage = ""
    var id = 0
    var imdb_id = ""
    var original_language = ""
    var original_title = ""
    var overview = ""
    var popularity = 0
    var poster_path = ""
    var release_date = ""
    var revenue = ""
    var runtime = ""
    var status = ""
    var title = ""
    var video = false
    var vote_average = 0.0
    var vote_count = 0
    
    class func getItem(endPoint: String, result:@escaping (MovieDetailEntity?)->()){
        
        var item = MovieDetailEntity()
        let urlString = Utility.serviceUrl() + "movie/\(endPoint)" + Utility.getApiKey()
        
        Alamofire.request(urlString).responseJSON { response in
            
            if let result = response.result.value {
                let json = JSON(result)
                print("JSON: \(json)") // serialized json response
                
                item = parseJson(json: json)
            }
            result(item)
        }
    }
    
    class func parseJson(json : JSON) -> MovieDetailEntity {
        let ent = MovieDetailEntity()
        
        ent.adult = json["adult"].boolValue
        ent.backdrop_path = Utility.imageUrl() + json["backdrop_path"].stringValue
        ent.budget = json["budget"].intValue
        for genre in json["genres"].arrayValue {
            ent.genres.append(genre["name"].stringValue)
        }
        ent.homepage = json["homepage"].stringValue
        ent.id = json["id"].intValue
        ent.imdb_id = json["imdb_id"].stringValue
        ent.original_language = json["original_language"].stringValue
        ent.original_title = json["original_title"].stringValue
        ent.overview = json["overview"].stringValue
        ent.popularity = json["popularity"].intValue
        ent.poster_path = Utility.imageUrl() + json["poster_path"].stringValue
        ent.release_date = json["release_date"].stringValue
        ent.revenue = json["revenue"].stringValue
        ent.runtime = json["runtime"].stringValue
        ent.status = json["status"].stringValue
        ent.title = json["Title"].stringValue
        ent.video = json["video"].boolValue
        ent.vote_average = json["vote_average"].doubleValue
        ent.vote_count = json["vote_count"].intValue
        
        return ent
    }
}
