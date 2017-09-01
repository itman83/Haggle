//
//  CircleImageView.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/22/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {


    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = self.bounds.size.width * 0.5
        self.clipsToBounds = true
    }
    
    

}
