//
//  Enums.swift
//  OMDB
//
//  Created by Taha Darendeli on 26.07.2019.
//  Copyright © 2019 Taha Darendeli. All rights reserved.
//
import UIKit

public enum StoryBoards : String {
    case MAIN = "Main"
    
    func get() -> UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}

public enum ViewControllers : String {
    case MOVIEDETAIL = "detail"
}
