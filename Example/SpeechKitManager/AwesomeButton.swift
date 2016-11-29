//
//  AwesomeButton.swift
//  SpeakToMe
//
//  Created by zaid.pathan on 25/11/16.
//  Copyright © 2016 Henry Mason. All rights reserved.
//

import UIKit

class AwesomeButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1
        layer.cornerRadius = 10
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 0.6
    }

}
