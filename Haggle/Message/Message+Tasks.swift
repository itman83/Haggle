//
//  Message+Tasks.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/25/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation
import RxSwift



// MARK: - Save Message

class SaveMessageTask: Operation {
    
    typealias Output = Void
    
    private let disposeBag = DisposeBag()
    private let chatroomId: String
    private let data: [String: AnyObject]
    
    var request: Request {
        return MessageRequest.saveMessage(chatroomId: chatroomId, data: data)
    }
    
    init(chatroomId: String, data: [String: AnyObject]) {
        self.chatroomId = chatroomId
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




// MARK: - Fetch Messages

class FetchMessagesTask: Operation {
    
    typealias Output = [Message]
    
    private let chatroomId: String
    private let disposeBag = DisposeBag()
    
    init(chatroomId: String) {
        self.chatroomId = chatroomId
    }
    
    var request: Request {
        return MessageRequest.fetchMessages(chatroomId: chatroomId)
    }
    
    func execute(in dispatcher: Dispatcher) -> Observable<[Message]> {
   
        return Observable.create { observer in
            dispatcher.execute(request: self.request)
                .subscribe(onNext: { response in            
                    switch response  {
                    case .json(let data):
                        var messages: [Message] = []
                        for (_, value) in data {
                            if let value = value as? [String: AnyObject],
                                let message = Message(json: value) {
                                messages.append(message)
                            }
                        }
                        observer.onNext(messages)
                    default: observer.onNext([])
                    }
                }).addDisposableTo(self.disposeBag)
            return Disposables.create()
        }
    }
}

