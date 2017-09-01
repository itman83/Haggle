//
//  Constants.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/30/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation


struct Constant {
    
    // should move this to AuthService class. 
    // need to extract this programmatically from Firebase so its never exposed like this.
    static let authToken = "XP40nS1GlN8c0Pdjb5XZ5NG9Td7ow5iYVgQODvzU"
    
    /// users
    static let id = "id"
    static let users = "users"
    static let name = "name"
    static let rating = "rating"
    static let ownerId = "ownerId"
    static let ownerName = "ownerName"
    static let ownerRating = "ownerRating"
    static let profileImageUrl = "profileImageUrl" 
    static let ownerProfileImageUrl = "ownerProfileImageUrl"
    static let ratings = "ratings"
    static let location = "location"
    
    static let items = "items"
    static let itemId = "itemId"
    static let imageUrl = "imageUrl"
    static let tags = "tags"
    static let buying = "buying"
    static let selling = "selling" 
    static let liked = "liked"
    static let bought = "bought"
    static let sold = "sold"
    static let archive = "archive"
    static let all = "all"
    
    static let messages = "messages"
    static let lastMessage = "lastMessage"
    static let recipientId = "recipientId"
    static let text = "text"
    static let timestamp = "timestamp"
    
    static let buyerId = "buyerId"
    static let sellerId = "sellerId"
    
    static let creationDate = "creationDate"
    static let expirationDate = "expirationDate"
    static let title = "title" 
    static let price = "price"
    static let info = "info"
    static let bidCount = "bidCount"
    static let bids = "bids"
    static let dollarAmount = "dollarAmount"
    
    static let chatroomId = "chatroomId"
    static let chatrooms = "chatrooms"
    static let members = "members"
    
    
}


