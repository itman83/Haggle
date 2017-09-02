//
//  User.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/27/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//


import Foundation 


struct User {
    
    var id: String
    var name: String
    var location: String
    var rating: Double
    var ratings: [String: Double]
    var tags: NSArray
    var profileImageUrl: String
    
}


extension User: JSONable {
    
    
    init?(json: [String : AnyObject]) {
        
        guard
            let id = json[Constant.id] as? String,
            let name = json[Constant.name] as? String,
            let location = json[Constant.location] as? String,
            let ratings = json[Constant.ratings] as? [String: Double],
            let tags = json[Constant.tags] as? NSArray,
            let profileImageUrl = json[Constant.profileImageUrl] as? String
        
            else {
                
                return nil
        }
        
        var rating = 0.0
        var count = 0.0
        for (_, value) in ratings {
            count += 1
            rating += value
        }
        
        rating /= count
        
        self.init(id: id,
                  name: name,
                  location: location,
                  rating: rating,
                  ratings: ratings,
                  tags: tags,
                  profileImageUrl: profileImageUrl)
    }
    
    
    func toJSON() -> [String: AnyObject] {
        
        let data: [String: AnyObject] = [
            Constant.id: id as AnyObject,
            Constant.name: name as AnyObject,
            Constant.location: location as AnyObject,
            Constant.ratings: ratings as AnyObject,
            Constant.tags: tags as AnyObject,
            Constant.profileImageUrl: profileImageUrl as AnyObject
        ]
        
        return data
    }
}


extension User: Hashable {
    
    var hashValue: Int {
        return id.hashValue
    }
    
}


extension User: Equatable {
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
}













