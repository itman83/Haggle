//
//  ItemCell.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/17/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ItemCell: UICollectionViewCell {
    
    // TODO: remove `item` prefix. Its redundent.
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemInfoLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    func prepare(with viewModel: ItemCellViewModel) {
        itemTitleLabel.text = viewModel.title
        itemInfoLabel.text = viewModel.price
        ratingLabel.text = viewModel.rating
        viewModel.image
            .observeOn(MainScheduler.instance)
            .map { UIImage(data: $0) }
            .bind(to: itemImageView.rx.image)
            .addDisposableTo(disposeBag)
    }
    
}
