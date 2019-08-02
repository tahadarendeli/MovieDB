//
//  Utility.swift
//  TMDB
//
//  Created by Taha Darendeli on 31.07.2019.
//  Copyright © 2019 Taha Darendeli. All rights reserved.
//

import UIKit

class Utility: NSObject {
    static func instantiate(name: String, withStoryboard: StoryBoards) -> UIViewController {
        return withStoryboard.get().instantiateViewController(withIdentifier: name)
    }
    
    static func serviceUrl() -> String {
        return "https://api.themoviedb.org/3/"
    }
    
    static func imageUrl() -> String {
        return "https://image.tmdb.org/t/p/original"
    }
    
    static func getApiKey() -> String {
        return "?api_key=6a7df57657d6ea8172c802bfa4f0f467"
    }
}
