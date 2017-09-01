//
//  RoundedTextView.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/16/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import UIKit

class RoundedTextView: UITextView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.clipsToBounds = true 
    }

}
