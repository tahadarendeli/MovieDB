//
//  MainTabBarController.swift
//  TMDB
//
//  Created by Taha Darendeli on 31.07.2019.
//  Copyright © 2019 Taha Darendeli. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBar.items![0].image = #imageLiteral(resourceName: "tab-movies").withRenderingMode(.alwaysOriginal)
        self.tabBar.items![0].selectedImage = #imageLiteral(resourceName: "tab-movies-selected").withRenderingMode(.alwaysOriginal)
        self.tabBar.items![0].title = "MOVIES"
        self.tabBar.items![1].image = #imageLiteral(resourceName: "tab-tv").withRenderingMode(.alwaysOriginal)
        self.tabBar.items![1].selectedImage = #imageLiteral(resourceName: "tab-tv-selected").withRenderingMode(.alwaysOriginal)
        self.tabBar.items![1].title = "TV"
        self.tabBar.items![2].image = #imageLiteral(resourceName: "tab-profile").withRenderingMode(.alwaysOriginal)
        self.tabBar.items![2].selectedImage = #imageLiteral(resourceName: "tab-profile-selected").withRenderingMode(.alwaysOriginal)
        self.tabBar.items![2].title = "PROFILE"
        self.tabBar.tintColor = UIColor(red: 204 / 255.0, green: 83 / 255.0, blue: 84 / 255.0, alpha: 1.0)
        
//        CC5354
    }
}
