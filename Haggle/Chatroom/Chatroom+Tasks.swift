//
//  Chatroom+Tasks.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/25/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation
import RxSwift 



// MARK: - Save Chatroom

class SaveChatroomTask: Operation {
    
    typealias Output = Void
    
    private let disposeBag = DisposeBag()
    
    let data: [String: AnyObject]
    
    var request: Request {
        return ChatroomRequest.saveChatroom(data: data)
    }
    
    init(data: [String: AnyObject]) {
        self.data = data
    }
    
    
    func execute(in dispatcher: Dispatcher) -> Observable<Void> {
        
        return Observable.create { observer in
            
            dispatcher.execute(request: self.request)
                .subscribe(onNext: {
                    switch $0 {
                    case .error(_, let error):
                        if let error = error {
                            print("Debugger: error -> \(error.localizedDescription)")
                            //observer.onError(error)
                        }
                        
                    default: break
                    }
                    
                }).addDisposableTo(self.disposeBag)
            
            return Disposables.create()
        }
    }
    
}



// MARK: - Update Chatroom

class UpdateChatroomTask: Operation {
    
    typealias Output = Void
    
    private let disposeBag = DisposeBag()
    
    let data: [String: AnyObject]
    let id: String
    
    var request: Request {
        return ChatroomRequest.update(data: data, id: id)
    }
    
    init(data: [String: AnyObject], id: String) {
        self.data = data
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
                            //observer.onError(error)
                        }
                        
                    default: break
                    }
                    
                }).addDisposableTo(self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    
}



// MARK: - Fetch Chatroom

class FetchChatroomsTask: Operation {
    
    typealias Output = [Chatroom]
    
    private let disposeBag = DisposeBag()
    
    var request: Request {
        return ChatroomRequest.fetchChatrooms
    }
    
    init() {
        
    }
    
    func execute(in dispatcher: Dispatcher) -> Observable<[Chatroom]> {
        return Observable.create { observer in
            dispatcher.execute(request: self.request)
                .subscribe(onNext: { response in
                    switch response {
                    case .json(let data):
                        var chatrooms: [Chatroom] = []
                        for (_, value) in data {
                            if let value = value as? [String: AnyObject],
                                let chatroom = Chatroom(json: value) {
                                chatrooms.append(chatroom)
                            }
                        }
                        observer.onNext(chatrooms)
                        
                    default: observer.onNext([])
                    }
                    
                }).addDisposableTo(self.disposeBag)
            
            return Disposables.create()
        }
    }
}


// MARK: - Remove Chatroom

class RemoveChatroomTask: Operation {
    
    typealias Output = Void
    
    private let disposeBag = DisposeBag()
    
    let id: String
    
    var request: Request {
        return ChatroomRequest.removeChatroom(id: id)
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
                            //observer.onError(error)
                        }
                    default: break
                    }
                    
                }).addDisposableTo(self.disposeBag)
            
            return Disposables.create()
        }
    }
}
