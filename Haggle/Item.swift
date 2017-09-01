//
//  Item.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/11/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation 

struct Item {
    
    let id: String
    let ownerId: String
    let ownerRating: Double
    let ownerName: String
    let ownerProfileImageUrl: String
    let creationDate: Double
    let expirationDate: Double
    let title: String
    let price: Int
    let info: String
    let imageUrl: String
    let bidCount: Int
    let tags: NSArray
    let location: String
}


extension Item: Hashable {
    
    var hashValue: Int {
        return id.hashValue
    }
}



extension Item: Equatable {
    
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
    
}


extension Item: JSONable {
    
    init?(json: [String: AnyObject]) {

        guard
            let id = json[Constant.id] as? String,
            let ownerId = json[Constant.ownerId] as? String,
            let ownerRating = json[Constant.ownerRating] as? Double,
            let ownerName = json[Constant.ownerName] as? String,
            let ownerProfileImageUrl = json[Constant.ownerProfileImageUrl] as? String,
            let creationDate = json[Constant.creationDate] as? Double,
            let expirationDate = json[Constant.expirationDate] as? Double,
            let title = json[Constant.title] as? String,
            let price = json[Constant.price] as? Int,
            let info = json[Constant.info] as? String,
            let imageUrl = json[Constant.imageUrl] as? String,
            let bidCount = json[Constant.bidCount] as? Int,
            let tags = json[Constant.tags] as? NSArray,
            let location = json[Constant.location] as? String
            
            else {
            print("DEBUGGER: could not init item object. ")
            return nil
        }
        
        self.init(id: id,
                  ownerId: ownerId,
                  ownerRating: ownerRating,
                  ownerName: ownerName,
                  ownerProfileImageUrl: ownerProfileImageUrl,
                  creationDate: creationDate,
                  expirationDate: expirationDate,
                  title: title,
                  price: price,
                  info: info,
                  imageUrl: imageUrl,
                  bidCount: bidCount,
                  tags: tags,
                  location: location)
    }
    
    
    
    
    func toJSON() -> [String: AnyObject] {
        
        let data: [String: AnyObject] = [
            
            Constant.id: id as AnyObject,
            Constant.ownerId: ownerId as AnyObject,
            Constant.ownerRating: ownerRating as AnyObject,
            Constant.ownerName: ownerName as AnyObject,
            Constant.ownerProfileImageUrl: ownerProfileImageUrl as AnyObject,
            Constant.creationDate: creationDate as AnyObject,
            Constant.expirationDate: expirationDate as AnyObject,
            Constant.title: title as AnyObject,
            Constant.price: price as AnyObject,
            Constant.info: info as AnyObject,
            Constant.imageUrl: imageUrl as AnyObject,
            Constant.bidCount: bidCount as AnyObject,
            Constant.tags: tags as AnyObject,
            Constant.location: location as AnyObject
        ]
        
        return data
    }
    
}




















