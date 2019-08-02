//
//  Extensions.swift
//  TMDB
//
//  Created by Taha Darendeli on 31.07.2019.
//  Copyright © 2019 Taha Darendeli. All rights reserved.
//

import UIKit

class Extensions: NSObject {

}

extension UIImageView {
    func applyShadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 10
        containerView.layer.cornerRadius = cornerRadious
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
    }
}
