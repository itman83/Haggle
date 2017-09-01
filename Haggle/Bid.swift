//
//  Bid.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/11/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation


struct Bid {
    
    let id: String
    let itemId: String
    let ownerId: String
    let ownerName: String
    let profileImageUrl: String
    let dollarAmount: Int
}



extension Bid: Hashable {

    var hashValue: Int {
        return id.hashValue
    }
}




extension Bid: Equatable {
    
    static func == (lhs: Bid, rhs: Bid) -> Bool {
        return lhs.id == rhs.id
    }
}



extension Bid: JSONable {


    init?(json: [String: AnyObject]) {
        guard let id = json[Constant.id] as? String,
            let itemId = json[Constant.itemId] as? String,
            let ownerId = json[Constant.ownerId] as? String,
            let ownerName = json[Constant.ownerName] as? String,
            let profileImageUrl = json[Constant.profileImageUrl] as? String,
            let dollarAmount = json[Constant.dollarAmount] as? Int
            else {
            return nil
        }
        
        
        self.init(id: id,
                  itemId: itemId,
                  ownerId: ownerId,
                  ownerName: ownerName,
                  profileImageUrl: profileImageUrl,
                  dollarAmount: dollarAmount)
    }
    
    
    
    func toJSON() -> [String: AnyObject] {
        
        let data: [String: AnyObject] = [
            Constant.id: id as AnyObject,
            Constant.itemId: itemId as AnyObject,
            Constant.ownerId: ownerId as AnyObject,
            Constant.ownerName: ownerName as AnyObject,
            Constant.profileImageUrl: profileImageUrl as AnyObject,
            Constant.dollarAmount: dollarAmount as AnyObject
        ]
        
        return data
    }
    
}
