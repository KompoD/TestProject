//
//  Animations.swift
//  Challenge
//
//  Created by Nikita Merkel on 10/10/2018.
//  Copyright © 2018 Nikita Merkel. All rights reserved.
//

import UIKit

class Animations {
    private init() {}
    
    static func scaleAndHide(view: UIView) {
        UIView.animate(withDuration: 0.3, animations: {() in
            view.layer.opacity = 0
            view.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        }, completion: {
            (_) in
            view.removeFromSuperview()
        })
    }
}
