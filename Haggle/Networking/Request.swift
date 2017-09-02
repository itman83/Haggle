//
//  Request.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/11/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation


protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var body: [String: AnyObject]? { get }
    var dataType: DataType { get }
}

