//
//  ChatroomRequest.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/25/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation


enum ChatroomRequest {
    case saveChatroom(data: [String: AnyObject])
    case update(data: [String: AnyObject], id: String)
    case fetchChatrooms
    case removeChatroom(id: String)
}


extension ChatroomRequest: Request {
    
    var path: String {
        switch self {
        case .saveChatroom(let data): return "/\(Constant.chatrooms)/\(String(describing: data[Constant.id]))"
        case .update(_ , let id): return "/\(Constant.chatrooms)/\(id)"
        case .fetchChatrooms: return "/\(Constant.chatrooms)"
        case .removeChatroom(let id): return "\(Constant.chatrooms)/\(id)"
        }
    }
    
    
    var method: HTTPMethod {
        switch self {
        case .saveChatroom: return .put
        case .update: return .patch
        case .fetchChatrooms: return .get
        case .removeChatroom: return .delete
        }
    }
    
    
    var body: [String: AnyObject]? {
        switch self {
        case .saveChatroom(let data), .update(let data, _): return data
        default: return nil
        }
    }
    
    
    var dataType: DataType {
        return .json
    }
    
}
