//
//  RoundedTextField.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/24/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import UIKit

class RoundedTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }

}
