//
//  ShadowView.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/22/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
    }

}
