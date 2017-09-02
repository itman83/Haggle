//
//  InboxCategory.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/25/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation

// Descibes the type of messages a users inbox can contain. Either items they have bought, or sold.
enum InboxCategory: Int {
    case sold
    case bought
}
