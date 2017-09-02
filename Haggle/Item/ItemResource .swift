//
//  Resource .swift
//  Haggle
//
//  Created by Aamahd Walker on 8/11/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation

// Describes the different locations an Item can be persisted at in database. 

enum ItemResource: Int {
    case buying
    case selling
    case liked
    case all
}

extension ItemResource: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .buying: return Constant.buying
        case .selling: return Constant.selling
        case .liked: return Constant.liked
        case .all: return Constant.items
        }
    }
    
}
