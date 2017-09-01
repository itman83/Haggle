//
//  AuthError.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/25/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation

enum AuthError: Error {
    
    case invalidAccesToken
    case invalidProfileData
    case invalidFirebaseUser
    case authorizationFailure
    case facebookGraphRequestFailed
    case custom(message: String)
    
}

extension AuthError {
    
    var localizedDescription: String {
        
        switch self {
            
        case .invalidAccesToken: return "Invalid Access Token."
        case .facebookGraphRequestFailed: return "Facebook graph request failed."
        case .invalidProfileData: return "Error retrieving facebook profile data"
        case .invalidFirebaseUser: return "Error retrieving Firebase User"
        case .authorizationFailure: return "Authorization failure "
        case .custom(let message): return message
            
        }
    }
}
