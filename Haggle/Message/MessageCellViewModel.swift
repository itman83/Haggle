//
//  MessageCellViewModel.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/16/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation
import RxSwift

class MessageCellViewModel {
    
    var text: String
    var image: Observable<Data>
    
    init(_ message: Message) {
        text = message.text
        image = ImageAPI.downloadImage(urlString: message.profileImageUrl, type: .item)
    }
    
}
