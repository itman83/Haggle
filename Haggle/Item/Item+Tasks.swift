//
//  Item+Fetch.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/11/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation
import RxSwift


// MARK: - Save Item

class SaveItemTask: Operation {
    
    typealias Output = Void
    
    private let disposeBag = DisposeBag()
    private let resource: ItemResource
    private let data: [String: AnyObject]
    
    var request: Request {
        return ItemRequest.saveItem(data: data, resource: resource)
    }
    
    init(data: [String: AnyObject], resource: ItemResource) {
        self.data = data
        self.resource = resource
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



// MARK: - Update Item

class UpdateItemTask: Operation {
    
    typealias Output = Void
    
    private let disposeBag = DisposeBag()
    private let data: [String: AnyObject]
    private let userId: String
    private let itemId: String
    private let resource: ItemResource
    
    var request: Request {
        return ItemRequest.update(data: data, itemId: itemId, userId: userId, resource: resource)
    }
    
    init(data: [String: AnyObject], itemId: String, userId: String, resource: ItemResource) {
        self.data = data
        self.userId = userId
        self.itemId = itemId
        self.resource = resource
    }
    
    
    func execute(in dispatcher: Dispatcher) -> Observable<Void> {
        
        return Observable.create { observer in
            dispatcher.execute(request: self.request)
                .subscribe(onNext: { response -> Void in
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



// MARK: - Fetch Items

class FetchItemsTask: Operation {
    
    typealias Output = [Item]
    
    private let disposeBag = DisposeBag()
    private let resource: ItemResource
    
    var request: Request {
        return ItemRequest.fetchItems(resource: resource)
    }
    
    
    init(resource: ItemResource) {
        self.resource = resource
    }
    
    
    func execute(in dispatcher: Dispatcher) -> Observable<[Item]> {
        
        return dispatcher.execute(request: self.request)
            .map { response -> [Item] in
                switch response {
                case .json(let data):
                    var items = [Item]()
                    for (_, value) in data {
                        if let value = value as? [String: AnyObject],
                            let item = Item(json: value) {
                            items.append(item)
                        }
                    }
                    return items
                    
                default: return []
                }
        }
    }
    
}





// MARK: - Remove Item

class RemoveItemTask: Operation {
    
    typealias Output = Void
    
    private let disposeBag = DisposeBag()
    private let id: String
    private let userId: String
    private let resource: ItemResource
    
    var request: Request {
        return ItemRequest.removeItem(id: id, userId: userId, resource: resource)
    }
    
    
    init(id: String, userId: String, resource: ItemResource) {
        self.id = id
        self.userId = userId
        self.resource = resource
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







