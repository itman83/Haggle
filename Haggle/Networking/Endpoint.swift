//
//  Endpoint.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/30/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation

protocol Endpoint {
    
    var base: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var body: [String: AnyObject]? { get }
}


extension Endpoint {
    
    private var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path + ".json" + "?auth=\(Constant.authToken)"
        return components
        
    }
    
    var request: URLRequest {

        var request = URLRequest(url: urlComponents.url!)
        
        request.httpMethod = self.method.rawValue

        if let body = body {
            do {
                let json = try JSONSerialization.data(withJSONObject: body, options: [])
                request.httpBody = json
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return request
    }
}
