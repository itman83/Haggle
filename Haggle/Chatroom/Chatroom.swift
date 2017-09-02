//
//  Chatroom.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/14/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation
import RxSwift



struct Chatroom {
    let id: String
    let sellerId: String
    let buyerId: String
    let itemId: String 
    let title: String
    let imageUrl: String
    let lastMessage: String
    let timestamp: Double
    let price: Int
}


extension Chatroom: JSONable {
    
    init?(json: [String: AnyObject]) {
        guard let id = json[Constant.id] as? String,
            let sellerId = json[Constant.sellerId] as? String,
            let buyerId = json[Constant.buyerId] as? String,
            let itemId = json[Constant.itemId] as? String,
            let title = json[Constant.title] as? String,
            let imageUrl = json[Constant.imageUrl] as? String,
            let timestamp = json[Constant.timestamp] as? Double,
            let lastMessage = json[Constant.lastMessage] as? String,
            let price = json[Constant.price] as? Int
            else {
            return nil
        }
        
        self.init(id: id, sellerId: sellerId,
                  buyerId: buyerId,
                  itemId: itemId,
                  title: title,
                  imageUrl: imageUrl,
                  lastMessage: lastMessage,
                  timestamp: timestamp,
                  price: price)
    }
    
    
    func toJSON() -> [String: AnyObject] {
        let data: [String: AnyObject] = [
            Constant.id: id as AnyObject,
            Constant.sellerId: sellerId as AnyObject,
            Constant.buyerId: buyerId as AnyObject,
            Constant.itemId: itemId as AnyObject,
            Constant.title: title as AnyObject,
            Constant.imageUrl: imageUrl as AnyObject,
            Constant.lastMessage: lastMessage as AnyObject,
            Constant.timestamp: timestamp as AnyObject,
            Constant.price: price as AnyObject
        ]
        return data
    }
    
}


extension Chatroom: Equatable {
    static func == (lhs: Chatroom, rhs: Chatroom) -> Bool {
        return lhs.id == rhs.id
    }
}


extension Chatroom: Hashable {
    var hashValue: Int {
        return id.hashValue
    }
}





