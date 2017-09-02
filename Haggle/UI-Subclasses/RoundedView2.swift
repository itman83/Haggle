//
//  RoundedView2.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/25/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import UIKit

class RoundedView2: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    

}
