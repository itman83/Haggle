//
//  NetworkError.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/30/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case invalidData
    case requestFailed
    case jsonSerializationFailure
    case initializationFailure
    case custom(message: String)
}



extension NetworkError {
    
    var localizedDescription: String {
        
        switch self {
        case .invalidResponse:
            return "Invalid network response."
        case .invalidData:
            return "Invalid Data"
        case .requestFailed:
            return "Network request failure."
        case .jsonSerializationFailure:
            return "JSON Serialization Failure."
        case .initializationFailure:
            return "Object Initialization Failure."
        case .custom(let message):
            return message
            
        }
    }
}


