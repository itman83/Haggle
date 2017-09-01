//
//  OutgoingMessageCell.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/16/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import UIKit
import RxSwift

class OutgoingMessageCell: UITableViewCell {
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func prepare(with viewModel: MessageCellViewModel) {
        
        messageTextView.text = viewModel.text
        
        viewModel.image
            .observeOn(MainScheduler.instance)
            .map { UIImage(data: $0) }
            .bind(to: profileImageView.rx.image)
            .addDisposableTo(disposeBag)
    }
    
    
}
