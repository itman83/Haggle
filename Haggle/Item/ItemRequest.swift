//
//  Item+Request.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/11/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation

enum ItemRequest {
    case saveItem(data: [String: AnyObject], resource: ItemResource)
    case fetchItems(resource: ItemResource)
    case update(data: [String: AnyObject], itemId: String, userId: String, resource: ItemResource)
    case removeItem(id: String, userId: String, resource: ItemResource)
}


extension ItemRequest: Request {
    
    
    var path: String {
        
        switch self {
            
        case .saveItem(let data, let resource):
            switch resource {
            case .buying, .selling, .liked:
                return "/\(resource.description)/\(AuthService.shared.currentUser.id)/\(String(describing: data[Constant.id]))"
            case .all: return "/\(resource.description)/\(String(describing: data[Constant.id]))"
            }
            
            
        case .fetchItems(let resource):
            switch resource {
            case .buying, .selling, .liked: return "/\(resource.description)/\(AuthService.shared.currentUser.id)"
            case .all: return "/\(resource.description)"
            }
            
        case .update(_, let itemId, let userId, let resource):
            switch resource {
            case .buying, .selling, .liked:
                return "/\(resource.description)/\(userId)/\(itemId)"
            case .all: return "/\(resource.description)/\(itemId)"
            }
            
        case .removeItem(let id, let userId, let resource):
            switch resource {
            case .buying, .selling, .liked: return "/\(resource.description)/\(userId)/\(id)"
            case .all: return "/\(resource.description)/\(id)"
            }
        }
        
    }
    
    
    var method: HTTPMethod {
        switch self {
        case .saveItem: return .put
        case .fetchItems: return .get
        case .update: return .patch
        case .removeItem: return .delete
            
        }
    }
    
    
    public var body: [String: AnyObject]? {
        switch self {
        case .saveItem(let data, _), .update(let data, _, _, _): return data
        default: return nil
            
        }
    }
    
    
    var dataType: DataType {
        return .json
    }
    
    
}
