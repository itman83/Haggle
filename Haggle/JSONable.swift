//
//  JSONable.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/30/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation

// Entities/Models conform to JSONable protocol to facilitate web service transactions.

protocol JSONable {
    init?(json: [String: AnyObject])
    func toJSON() -> [String: AnyObject]
    
}
