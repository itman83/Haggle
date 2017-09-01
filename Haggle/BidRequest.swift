//
//  Bid+Request.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/11/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation


enum BidRequest {
    case saveBid(itemId: String, data: [String: AnyObject])
    case fetchBids(itemId: String)
    case removeBids(itemId: String)
}

extension BidRequest: Request {
    
    var path: String {
        switch self {
        case .saveBid(let itemId, _): return "/\(Constant.bids)/\(itemId)/\(AuthService.shared.currentUser.id)"
        case .fetchBids(let itemId): return "/\(Constant.bids)/\(itemId)"
        case .removeBids(let itemId): return "/\(Constant.bids)/\(itemId)"
        }
    }
    
    
    var method: HTTPMethod {
        switch self {
        case .saveBid: return .put
        case .fetchBids: return .get
        case .removeBids: return .delete
        }
    }
    
    
    var body: [String: AnyObject]? {
        switch self {
        case .saveBid(_, let data): return data
        default: return nil
        }
    }
    
    
    var dataType: DataType {
        return .json
    }

    
}
