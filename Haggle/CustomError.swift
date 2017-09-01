//
//  CustomError.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/25/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation


enum CustomError: Error {
    case invalidImage
    case invalidItem
}


extension CustomError {
    var localizedDescription: String {
        switch self {
        case .invalidItem: return "Error: One or more item properties are invalid."
        case .invalidImage: return "Error: Image is either nil or could not be translated to JPEG format."
        }
    }
}
