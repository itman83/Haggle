//
//  MyAccountCell.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/26/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import UIKit

class MyAccountCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel! 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
