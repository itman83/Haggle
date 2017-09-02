//
//  SearchViewModel.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/1/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation
import RxSwift


class SearchViewModel {
    
    // MARK: - Dependencies
    private let dispatcher: Dispatcher
    
    // MARK: - Outlets
    var collectionItems = Observable<[Item]>.of([])
    var error: Observable<Error>?
    
    
    // MARK: - Init
    init(dispatcher: Dispatcher, segment: Observable<Int>, searchText: Observable<String?>) {
        self.dispatcher = dispatcher
        fetchItems(for: segment, containing: searchText)
        
    }

    
    private func fetchItems(for segment: Observable<Int>, containing text: Observable<String?>) {
        
        let fetchedItems = FetchItemsTask(resource: .all)
            .execute(in: dispatcher)
            .filter { !$0.isEmpty }
            .flatMap { items -> Observable<[Item]> in
                return segment
                    .map { ItemCategory(rawValue: $0) }
                    .filter { $0 != nil }.map { $0! }
                    .flatMapLatest { category -> Observable<[Item]> in
                        return self.rx_segmentedItems(for: category, items: items)
                        
                }
            }
            .shareReplayLatestWhileConnected()
        
        // results combines items for a given segment with latest text to produce results.
        // `text` represent a tag/keyword that items could be identified with.
        let results = Observable
            .combineLatest(fetchedItems, text) { (items, tag) -> [Item] in
                guard tag != "" else {
                    return items
                }
                let filtered = items.filter { $0.tags.contains(tag!) }
                return filtered
            }
            .materialize()
            .filter { !$0.isCompleted }
            .shareReplayLatestWhileConnected()
        
        collectionItems = results.filter { $0.element != nil }.dematerialize()
        error = results.filter { $0.error != nil }.map { $0.error! }
        
    }
    
    
    
    // MARK: - Helper Methods
    
    private func rx_segmentedItems(for category: ItemCategory, items: [Item]) -> Observable<[Item]> {
        switch category {
        case .forYou: return rx_forYouItems(items: items)
        case .local: return rx_localItems(items: items)
        case .trending: return rx_trendingItems(items: items)
        case .recentlyAdded: return rx_recentlyAddedItems(items: items)
        }
    }
    
    private func rx_localItems(items: [Item]) -> Observable<[Item]> {
        return Observable<[Item]>.create { observer in
            observer.onNext(items.filter { $0.location == AuthService.shared.currentUser.location })
            return Disposables.create()
        }
    }
    
    private func rx_recentlyAddedItems(items: [Item]) -> Observable<[Item]> {
        return Observable<[Item]>.create { observer in
            let recentItems = items
                .filter {
                    let now = Date()
                    let creationDate = Date(timeIntervalSince1970: $0.creationDate)
                    if let hoursAgo = now.hours(from: creationDate) {
                        return hoursAgo < 24
                    } else {
                        return false
                    }
            }
            observer.onNext(recentItems)
            return Disposables.create()
        }
    }
    
    
    private func rx_trendingItems(items: [Item]) -> Observable<[Item]> {
        return Observable<[Item]>.create { observer in
            observer.onNext(items
                .filter { $0.bidCount > 5 })
            return Disposables.create()
        }
    }
    
    
    private func rx_forYouItems(items: [Item]) -> Observable<[Item]> {
        return Observable<[Item]>.create { observer in
            let forYouItems = items
                .filter { item in
                    
                    let itemTags: Set<String> = Set((NSMutableArray(array: item.tags)
                        .flatMap { $0 as? String } as [String]))
                    
                    let user = AuthService.shared.currentUser
                    let userTags: Set<String> = Set((NSMutableArray(array: user.tags)
                        .flatMap { $0 as? String } as [String]))
                    
                    // Jaccard Similarity: Intersection(A,B) / Union(A,B)
                    let jaccardIndex = Double(itemTags.intersection(userTags).count) / Double(itemTags.union(userTags).count)
                    
                    return jaccardIndex >= 0.5
            }
            observer.onNext(forYouItems)
            return Disposables.create()
        }
    }
    
    
}


extension SearchViewModel {
    
    // MARK: - Item Category
    
    
    // category of items that reflect segmented control options.
    enum ItemCategory: Int {
        case forYou
        case trending
        case local
        case recentlyAdded
    }
    
}














