//
//  InboxViewModel.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/15/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class InboxViewModel {
    
    private let dispatcher: Dispatcher
    var chatroom: Chatroom? 
    var chatrooms = Observable<[Chatroom]>.of([])
    var error: Observable<Error>?
    
    init (dispatcher: Dispatcher, segment: Observable<Int>) {
        self.dispatcher = dispatcher
        fetchChatrooms(for: segment)
    }
    
    
    func fetchChatrooms(for segment: Observable<Int>) {
        
        let fetchedChatrooms = FetchChatroomsTask().execute(in: dispatcher)
            .filter { !$0.isEmpty }
            .flatMap { chatroomList -> Observable<Event<[Chatroom]>> in
                return segment
                    .map { InboxCategory(rawValue: $0) }
                    .filter { $0 != nil }.map { $0! }
                    .flatMap { category -> Observable<Event<[Chatroom]>> in
                        switch category {
                        case .sold:
                            return Observable<[Chatroom]>.of(chatroomList
                                .filter { $0.sellerId == AuthService.shared.currentUser.id})
                                .materialize()
                        case .bought:
                            return Observable<[Chatroom]>.of(chatroomList
                                .filter { $0.buyerId == AuthService.shared.currentUser.id  })
                                .materialize()
                        }
                    }
                    .filter { !$0.isCompleted }
                    .shareReplayLatestWhileConnected()
        }
        
        chatrooms = fetchedChatrooms.filter { $0.element != nil }.dematerialize()
        error = fetchedChatrooms.filter { $0.error != nil }.map { $0.error! }
        
    }
    
    

}















