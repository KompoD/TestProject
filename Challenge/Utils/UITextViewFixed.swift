//
//  UITextViewFixed.swift
//  Challenge
//
//  Created by Nikita Merkel on 11/10/2018.
//  Copyright © 2018 Nikita Merkel. All rights reserved.
//

import UIKit

@IBDesignable class UITextViewFixed: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
}
