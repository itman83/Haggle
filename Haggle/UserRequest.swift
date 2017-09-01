//
//  User+Request.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/11/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation

enum UserRequest {

    case saveUser(data: [String: AnyObject])
    case fetchUser(id: String)
    case update(data: [String: AnyObject], id: String)
    case removeUser(id: String)
    
}


extension UserRequest: Request {
    
    var path: String {
        
        switch self {
        case .saveUser(let data): return "/\(Constant.users)/\(String(describing: data[Constant.id]))"
        case .update(_, let id): return "/\(Constant.users)/\(id)"
        case .fetchUser(let id): return "/\(Constant.users)/\(id)"
        case .removeUser(let id): return "/\(Constant.users)/\(id)"
            
        }
        
    }
    
    
    var method: HTTPMethod {
        switch self {
        case .saveUser: return .put
        case .update: return .patch
        case .fetchUser: return .get
        case .removeUser: return .delete
        }
        
    }
    
    
    var body: [String: AnyObject]? {
        switch self {
        case .saveUser(let data), .update(let data, _): return data
        default: return nil
        }
        
    }

    
    var dataType: DataType {
        return .json
    }
    
    
    
}
