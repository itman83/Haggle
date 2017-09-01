//
//  MessageCell.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/23/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import UIKit
import RxSwift

class InboxCell: UITableViewCell {
    
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func prepare(with viewModel: InboxCellViewModel) {
        itemTitleLabel.text = viewModel.title
        lastMessageLabel.text = viewModel.lastMessage
        priceLabel.text = viewModel.price
        viewModel.image
            .observeOn(MainScheduler.instance)
            .map { UIImage(data: $0) }
            .bind(to: itemImageView.rx.image)
            .addDisposableTo(disposeBag)
    }
    
}
