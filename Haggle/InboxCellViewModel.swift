//
//  ChatroomCellViewModel.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/15/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation
import RxSwift


class InboxCellViewModel {
    
    let title: String
    let lastMessage: String
    let price: String
    let image: Observable<Data>
    
    init(_ chatroom: Chatroom) {
        self.title = chatroom.title
        self.lastMessage = chatroom.lastMessage
        self.price = "$\(chatroom.price)"
        self.image = ImageAPI.downloadImage(urlString: chatroom.imageUrl, type: .item)
    }
    
}
