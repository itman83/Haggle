//
//  BorderedTextField.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/16/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import UIKit

class BorderedTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 1
        let lightGray = UIColor(colorLiteralRed: 184/255, green: 184/255, blue: 184/255, alpha: 0.4)
        self.layer.borderColor = lightGray.cgColor
        self.clipsToBounds = true
        
    }
    
    

}
