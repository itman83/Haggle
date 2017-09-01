//
//  ChatroomViewModel .swift
//  Haggle
//
//  Created by Aamahd Walker on 8/15/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation
import RxSwift


class ChatroomViewModel {
    
    private let dispatcher: Dispatcher
    private let disposeBag = DisposeBag()
    let chatroom: Chatroom
    var messages = Observable<[Message]>.of([])
    var error: Observable<Error>?
    
    init(dispatcher: Dispatcher, chatroom: Chatroom) {
        self.dispatcher = dispatcher
        self.chatroom = chatroom
        fetchMessages()
    }
    
    func fetchMessages() {
        
        let fetchedMessages = Observable<Int>
            .interval(5, scheduler: MainScheduler.instance)
            .startWith(1)
            .flatMap { [weak self] _ -> Observable<Event<[Message]>> in
                guard let strongSelf = self else { return Observable<Event<[Message]>>.empty() }
                return  FetchMessagesTask(chatroomId: strongSelf.chatroom.id).execute(in: strongSelf.dispatcher)
                    .materialize()
            }
            .filter { !$0.isCompleted }
            .shareReplayLatestWhileConnected()
        
        
        messages = fetchedMessages
            .filter { $0.element != nil }
            .dematerialize()
            .map { $0.sorted(by: { (message1, message2) -> Bool in
                return message1.timestamp < message2.timestamp
            })
                
        }
        
        error = fetchedMessages.filter { $0.error != nil }.map { $0.error! }
    }
    
    
    func sendMessage(text: String?) {
        
        guard let text = text else {
            return
        }
        
        let message = Message(id: NSUUID().uuidString,
                              ownerId: AuthService.shared.currentUser.id,
                              profileImageUrl: AuthService.shared.currentUser.profileImageUrl,
                              text: text,
                              timestamp: Date().timeIntervalSince1970)
        
        
        let updatedChatroom: [String: AnyObject] = [Constant.lastMessage: message.text as AnyObject,
                                                    Constant.timestamp: message.timestamp as AnyObject]
        
        let saveMessageTask =  SaveMessageTask(chatroomId: chatroom.id, data: message.toJSON()).execute(in: dispatcher)
        let updateChatroomTask = UpdateChatroomTask(data: updatedChatroom, id: chatroom.id).execute(in: dispatcher)
        
        Observable.combineLatest(saveMessageTask, updateChatroomTask)
            .materialize()
            .flatMap({ Observable.from(optional: $0.error) })
            .subscribe(onNext: { [weak self] (error) in
                self?.error = Observable.of(error)
            }).addDisposableTo(disposeBag)
    }
    
    
    private func updateChatroom(message: Message) {
        
        let updatedChatroom = [Constant.lastMessage: message.text, Constant.timestamp: message.timestamp] as [String: AnyObject]
        
        SaveChatroomTask(data: updatedChatroom).execute(in: dispatcher)
            .materialize()
            .flatMap({ Observable.from(optional: $0.error) })
            .subscribe(onNext: { [weak self] (error) in
                self?.error = Observable.of(error)
            }).addDisposableTo(disposeBag)
    }
    
    
    func removeChatroom() {
        
        RemoveChatroomTask(id: chatroom.id).execute(in: dispatcher)
            .materialize()
            .flatMap({ Observable.from(optional: $0.error) })
            .subscribe(onNext: { [weak self] (error) in
                self?.error = Observable.of(error)
            }).addDisposableTo(disposeBag)
    }
    
    
    func updateUserRatings(with rating: Int) {
        
        let key = NSUUID().uuidString
        let updatedRating: [String: Any] = [Constant.ratings: [key: rating]]
        var id: String?
        
        switch AuthService.shared.currentUser.id {
        case chatroom.buyerId: id = chatroom.sellerId
        case chatroom.sellerId: id = chatroom.buyerId
        default: break
        }
        
        guard let userId = id else {
            return
        }
        
        UpdateUserTask(data: updatedRating as [String : AnyObject], id: userId)
            .execute(in: dispatcher)
            .materialize()
            .flatMap({ Observable.from(optional: $0.error) })
            .subscribe(onNext: { [weak self] (error) in
                self?.error = Observable.of(error)
            }).addDisposableTo(disposeBag)
    }
    
}





