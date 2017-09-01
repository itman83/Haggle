//
//  AuctionCell.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/22/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// This should actually be named BidCell, since it is a visual representation of a Bid that takes place within an auction.
class AuctionCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    
    func prepare(with viewModel: AuctionCellViewModel) {
        
        nameLabel.text = viewModel.name
        priceLabel.text = viewModel.price
        infoLabel.text = viewModel.info
        viewModel.image
            .observeOn(MainScheduler.instance)
            .map { UIImage(data: $0) }
            .bind(to: profileImageView.rx.image)
            .addDisposableTo(disposeBag)
    }
    
    
    
    
}
