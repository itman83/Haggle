//
//  Bid+Tasks.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/11/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation
import RxSwift



// MARK: - Save Bid

class SaveBidTask: Operation {
    
    typealias Output = Void
    
    private let disposeBag = DisposeBag()
    private let itemId: String
    private let data: [String: AnyObject]
    
    var request: Request {
        return BidRequest.saveBid(itemId: itemId, data: data)
    }
    
    init(itemId: String, data: [String: AnyObject]) {
        self.itemId = itemId
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
                            //observer.onError(error)
                        }
                    default: break
                    }
                }).addDisposableTo(self.disposeBag)
            
            return Disposables.create()
        }
    }
}



// MARK: - Fetch Bids

class FetchBidsTask: Operation {
    
    
    typealias Output = [Bid]
    
    private let disposeBag = DisposeBag()
    private let itemId: String
    
    var request: Request {
        return BidRequest.fetchBids(itemId: itemId)
    }
    
    
    init(itemId: String) {
        self.itemId = itemId
        
    }
    
    
    func execute(in dispatcher: Dispatcher) -> Observable<[Bid]> {
        
        return Observable.create { observer in
            dispatcher.execute(request: self.request)
                .subscribe(onNext: { response in
                    switch response {
                    case .json(let data):
                        var bids: [Bid] = []
                        for (_, value) in data {
                            if let value = value as? [String: AnyObject],
                                let bid = Bid(json: value) {
                                bids.append(bid)
                            }
                        }
                        observer.onNext(bids)
                    default: observer.onNext([])
                    }
                }).addDisposableTo(self.disposeBag)
            return Disposables.create()
        }
    }
}



// MARK: - Remove Bid 

class RemoveBidsTask: Operation {
    
    typealias Output = Void
    
    private let disposeBag = DisposeBag()
    private let itemId: String
    
    var request: Request {
        return BidRequest.removeBids(itemId: itemId)
    }
    
    init(itemId: String) {
        self.itemId = itemId
    }
    
    
    func execute(in dispatcher: Dispatcher) -> Observable<Void> {
        
        return Observable.create { observer in
            dispatcher.execute(request: self.request)
                .subscribe(onNext: { response in
                    switch response {
                    case .error(_, let error):
                        if let error = error {
                            print("Debugger: error -> \(error.localizedDescription)")
                            //observer.onError(error)
                        }
                    default: observer.onNext()
                    }
                    
                }).addDisposableTo(self.disposeBag)
            
            return Disposables.create()
        }
    }
}














