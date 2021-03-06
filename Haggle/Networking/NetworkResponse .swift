//
//  Network Response .swift
//  Haggle
//
//  Created by Aamahd Walker on 8/11/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//


import Foundation

enum NetworkResponse {
    case json(_: [String: AnyObject])
    case data(_: Data)
    case error(_: Int?, _: Error?)
}


extension NetworkResponse {
    
    init(_ response: (r: HTTPURLResponse?, data: Data?, error: Error?), for request: Request) {
        
        guard response.r?.statusCode == 200 else {
            self = .error(response.r?.statusCode, response.error)
            return
        }
        
        guard let data = response.data else {
            self = .error(response.r?.statusCode, NetworkError.invalidData)
            return
        }
        
        if request.method == .get {
            switch request.dataType {
            case .data: self = .data(data)
            case .json:
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let data = json as? [String: AnyObject] {
                        self = .json(data)
                        return
                    } else {
                        self = .error(nil, NetworkError.custom(message: "Error downcasting JSON to expected type `[String: AnyObject]`"))
                        return
                    }
                } catch {
                    self = .error(nil, NetworkError.jsonSerializationFailure)
                    return
                }
            }
        } else {
            // If response is success, and no data is expected in return, just set associated value to empty dictionary.
            self = .json([:])
            return
        }
    }
}








