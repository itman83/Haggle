//
//  RoundedButton.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/22/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        //self.layer.borderColor = UIColor.black.cgColor
        //self.layer.borderWidth = 1
    }

}
