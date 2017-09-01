//
//  MessageRequest.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/25/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation


enum MessageRequest {
    case saveMessage(chatroomId: String, data: [String: AnyObject])
    case fetchMessages(chatroomId: String)
}


extension MessageRequest: Request {
    
    var path: String {
        switch self {
        case .saveMessage(let chatroomId, let data): return "/\(Constant.messages)/\(chatroomId)/\(String(describing: data[Constant.id]))"
        case .fetchMessages(let chatroomId): return "/\(Constant.messages)/\(chatroomId)"
        }
    }
    
    
    var method: HTTPMethod {
        switch self {
        case .saveMessage: return .put
        case .fetchMessages: return .get
        }
    }
    
    
    var body: [String: AnyObject]? {
        switch self {
        case .saveMessage(_, let data): return data
        default: return nil
        }
    }
    
    
    var dataType: DataType {
        return .json
    }
    
}
