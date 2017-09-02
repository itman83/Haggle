//
//  Dispatcher.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/11/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation
import RxSwift


// Repsoponsible for executing actual Network Request 

protocol Dispatcher {
    
    init()
    
    var host: String { get }
    
    func execute(request: Request) -> Observable<NetworkResponse>
}
