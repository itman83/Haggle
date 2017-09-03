//
//  User+Tasks.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/11/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation
import RxSwift


// MARK: - Save User

class SaveUserTask: Operation {
    
    typealias Output = Void
    
    private let disposeBag = DisposeBag()
    private let data: [String: AnyObject]
    
    var request: Request {
        return UserRequest.saveUser(data: data)
    }
    
    
    init(data: [String: AnyObject]) {
        self.data = data
    }
    
    
    func execute(in dispatcher: Dispatcher) -> Observable<Void> {
        return Observable.create { observer in
            dispatcher.execute(request: self.request)
                .subscribe(onNext: { response in
                    switch response {
                    case .error(_, let error):
                        if let error = error {
                            print("Debugger: error -> \(error.localizedDescription)")
                            observer.onError(error)
                        }
                    default: observer.onNext()
                    }
                }).addDisposableTo(self.disposeBag)
            return Disposables.create()
        }
    }
}




// MARK: - Update User

class UpdateUserTask: Operation {
    
    typealias Output = Void
    
    private let disposeBag = DisposeBag()
    private let data: [String: AnyObject]
    private let id: String
    
    var request: Request {
        return UserRequest.update(data: data, id: id)
    }
    
    init(data: [String: AnyObject], id: String) {
        self.data = data
        self.id = id
    }
    
    func execute(in dispatcher: Dispatcher) -> Observable<Void> {
        return Observable.create { observer in
            dispatcher.execute(request: self.request)
                .subscribe(onNext: { response in
                    switch response {
                    case .error(_, let error):
                        if let error = error {
                            print("Debugger: error -> \(error.localizedDescription)")
                            observer.onError(error)
                        }
                    default: observer.onNext()
                    }
                }).addDisposableTo(self.disposeBag)
            return Disposables.create()
        }
    }
}




// MARK: - Fetch User

class FetchUserTask: Operation {
    
    typealias Output = User
    
    private let disposeBag = DisposeBag()
    private let id: String
    
    var request: Request {
        return UserRequest.fetchUser(id: id)
    }
    
    init(id: String) {
        self.id = id
    }
    
    func execute(in dispatcher: Dispatcher) -> Observable<User> {
        return Observable<User>.create { observer in
            dispatcher.execute(request: self.request)
                .subscribe(onNext: {
                    switch $0 {
                    case .json(let data):
                        if let user = User(json: data) {
                            observer.onNext(user)
                        }
                    case .error(_, let error):
                        if let error = error {
                            print("Debugger: error -> \(error.localizedDescription)")
                            observer.onError(error)
                        }
                        
                    default: break
                    }
                }).addDisposableTo(self.disposeBag)
            
            return Disposables.create()
        }
    }
}




// MARK: - Remove User

class RemoveUserTask: Operation {
    
    typealias Output = Void
    
    private let disposeBag = DisposeBag()
    private let id: String
    
    var request: Request {
        return UserRequest.removeUser(id: id)
    }
    
    init(id: String) {
        self.id = id
    }
    
    func execute(in dispatcher: Dispatcher) -> Observable<Void> {
        return Observable.create { observer in
            dispatcher.execute(request: self.request)
                .subscribe(onNext: {
                    switch $0 {
                    case .error(_, let error):
                        if let error = error {
                            print("Debugger: error -> \(error.localizedDescription)")
                            observer.onError(error)
                        }
                    default: observer.onNext()
                    }
                }).addDisposableTo(self.disposeBag)
            
            return Disposables.create()
        }
    }
}

