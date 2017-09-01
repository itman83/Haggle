//
//  ClearNavBar.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/20/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import UIKit

class ClearNavBar: UINavigationBar {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // MARK: SET UI FOR NAVIGATION BAR CLEAR
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
        
    }

}
