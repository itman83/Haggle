//
//  MyItemsViewModel.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/7/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation
import RxSwift


class MyItemsViewModel {
    
    
    private let dispatcher: Dispatcher
    
    var collectionItems = Observable<[Item]>.of([])
    var error: Observable<Error>?
    
    
    init(dispatcher: Dispatcher, segment: Observable<Int>, searchText: Observable<String?> ) {
        self.dispatcher = dispatcher
        fetchItems(for: segment, containing: searchText)
        
    }
    
    
    func fetchItems(for segment: Observable<Int>, containing text: Observable<String?>) {
        
        let fetchedItems = Observable.combineLatest(segment, text)
            .flatMap { (segment, text) -> Observable<Event<[Item]>> in
                return FetchItemsTask(resource: ItemResource(rawValue: segment)!)
                    .execute(in: self.dispatcher)
                    .map { items -> [Item] in
                        guard text != "" else {
                            return items
                        }
                        return items.filter { $0.tags.contains(text!) }
                }.materialize()
            }
            .filter { !$0.isCompleted }
            .shareReplayLatestWhileConnected()
        
        collectionItems = fetchedItems.filter { $0.element != nil }.dematerialize()
        error = fetchedItems.filter { $0.error != nil }.map { $0.error! }
    }
    
    
}



















