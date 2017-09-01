//
//  CountdownResponse.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/25/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation


enum CountdownResponse {
    case isFinished
    case result(time: String)
    case error(message: String)
}
