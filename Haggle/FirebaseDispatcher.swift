//
//  FirebaseDispatcher.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/11/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//


import Foundation
import RxSwift


class FirebaseDispatcher: Dispatcher {
    
    internal let host: String
    
    private let session = URLSession.shared
    
    required init() {
        self.host = "https://haggle-81e4d.firebaseio.com"
    }
    
    func execute(request: Request) -> Observable<NetworkResponse> {
        return Observable<NetworkResponse>.create  { observer in
            do {
                let actualRequest = try self.prepareRequest(for: request)
                self.session.dataTask(with: actualRequest, completionHandler: { (data, response, error) in
                    let response = NetworkResponse.init((r: response as? HTTPURLResponse, data: data, error: error), for: request)
                    observer.onNext(response)
                    
                }).resume()
            }
            catch let error {
                // If I emit error here, I will short circuit future responses to observers. look into this.  
                print("Debugger: \(error.localizedDescription)")
            }
            
            return Disposables.create()
        }
    }
    
    
    
    private func prepareRequest(for request: Request) throws -> URLRequest {
        
        var urlComponents: URLComponents {
            var components = URLComponents(string: self.host)!
            components.path = request.path + ".json" + "?auth=\(Constant.authToken)"
            return components
        }
        
        guard let url = urlComponents.url else {
            throw NetworkError.custom(message: "Invalid URL")
        }
        
        var newRequest = URLRequest(url: url)
        
        newRequest.httpMethod = request.method.rawValue
        
        if let body = request.body {
            do {
                let json = try JSONSerialization.data(withJSONObject: body, options: [])
                newRequest.httpBody = json
            }
            catch {
                throw NetworkError.jsonSerializationFailure
            }
        }
        
        return newRequest
    }
    
    
}







