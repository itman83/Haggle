//
//  Operation.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/11/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation
import RxSwift


protocol Operation {
    
    associatedtype Output
    var request: Request { get }
    func execute(in dispatcher: Dispatcher) -> Observable<Output>
    
}
