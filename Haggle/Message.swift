//
//  Message.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/14/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation
import RxSwift


struct Message {
    let id: String
    let ownerId: String
    let profileImageUrl: String
    let text: String
    let timestamp: Double
}

extension Message: JSONable {
    
    init?(json: [String: AnyObject]) {
        
        guard let id = json[Constant.id] as? String,
            let ownerId = json[Constant.ownerId] as? String,
            let profileImageUrl = json[Constant.profileImageUrl] as? String,
            let text = json[Constant.text] as? String,
            let timestamp = json[Constant.timestamp] as? Double
            else {
            return nil
        }
        
        self.init(id: id, ownerId: ownerId, profileImageUrl: profileImageUrl, text: text, timestamp: timestamp)

    }
    
    
    func toJSON() -> [String : AnyObject] {
        
        let data: [String: AnyObject] = [
            Constant.id: id as AnyObject,
            Constant.ownerId: ownerId as AnyObject,
            Constant.profileImageUrl: profileImageUrl as AnyObject,
            Constant.text: text as AnyObject,
            Constant.timestamp: timestamp as AnyObject
        ]
        
        return data
        
    }
}


extension Message: Equatable {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
}


extension Message: Hashable {
    
    var hashValue: Int {
        return id.hashValue
    }
    
}














