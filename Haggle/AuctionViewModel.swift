//
//  AuctionViewModel.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/10/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class AuctionViewModel {
    
    private let dispatcher = FirebaseDispatcher()
    private let disposeBag = DisposeBag()
    var item: Item
    var maxBid: Bid?
    var timer: Timer?

    
    var countdown = Variable<String>("00 : 00 : 00 : 00")
    var submitButtonIsEnabled = Variable<Bool>(true)
    var bids = Observable<[Bid]>.of([])
    var error: Observable<Error>?
    
    var itemImage: Observable<Data> {
        return ImageAPI.downloadImage(urlString: self.item.imageUrl, type: .item)
    }

    
    init(dispatcher: Dispatcher, item: Item) {
        self.item = item
        startCountdown()
        fetchBids()
    }
    
    deinit {
        invalidateTimer()
    }
    
    
    func submitBid(amount: Int) {
        
        if let maxBid = self.maxBid {
            guard amount > maxBid.dollarAmount else {
                return
            }
        }
        
        // - procedure for submitting a bid:
        // 1. instantiate new Bid.
        // 2. save item to `buying` category/node for current bidder.
        // 3. increment bid count for item.
        // 4. combine tasks & execute by subscribing to cold observables.
        
        // 1
        let newBid = Bid(id: NSUUID().uuidString, itemId: item.id, ownerId: AuthService.shared.currentUser.id, ownerName:  AuthService.shared.currentUser.name, profileImageUrl:  AuthService.shared.currentUser.profileImageUrl, dollarAmount: amount)
        let saveBidTask = SaveBidTask(itemId: item.id, data: newBid.toJSON()).execute(in: dispatcher)
        
        // 2
        var buyingItem = item.toJSON()
        buyingItem[Constant.bidCount] = item.bidCount + 1 as AnyObject
        let buyingItemTask = SaveItemTask(data: buyingItem, resource: .buying).execute(in: self.dispatcher)
        
        // 3
        let updatedItem: [String: AnyObject] = [Constant.bidCount: item.bidCount + 1 as AnyObject]
        let updateItemTaskForSeller = updateItem(data: updatedItem, userId: item.ownerId, resource: .all, .selling)
        
        // 4
        let completeBidSubmission = Observable.combineLatest(saveBidTask, buyingItemTask, updateItemTaskForSeller)
        
        completeBidSubmission
            .materialize()
            .flatMap({ Observable.from(optional: $0.error) })
            .subscribe(onNext: { [weak self] (error) in
                self?.error = Observable.of(error)
            })
            .disposed(by: disposeBag)
    }
    
    
    private func fetchBids() {
        
        // Realistically since I'm using Firebase, I should consider using realtime database, and listen for added child values. Rather than having recurring requests.
        let fetchedBids = Observable<Int>
            .interval(1, scheduler: MainScheduler.instance)
            .startWith(1)
            // on this line consider using `.takeUntil(other:)` operator to stop recurring request if deallocated.
            .flatMap { [weak self] _ -> Observable<Event<[Bid]>> in
                guard let strongSelf = self else { return Observable<Event<[Bid]>>.empty() }
                return FetchBidsTask(itemId: strongSelf.item.id)
                    .execute(in: strongSelf.dispatcher)
                    .materialize()
                    .filter { !$0.isCompleted }
                    .shareReplayLatestWhileConnected()
        }
        
        
        bids = fetchedBids
            .filter { $0.element != nil }
            .dematerialize()
            .map { $0.sorted(by: { (bid1, bid2) -> Bool in
                return bid1.dollarAmount > bid2.dollarAmount })
            }.do(onNext: { [weak self] in
                if $0.count > 0 {
                    self?.maxBid = $0[0]
                }
            })
        
        error = fetchedBids.filter { $0.error != nil }.map { $0.error! }
        
    }
    
    
    private func startCountdown() {
        
        let expirationDate = Date(timeIntervalSince1970: item.expirationDate)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            let currentDate = Date()
            let response = currentDate.countdown(to: expirationDate)
            switch response {
            case .result(let time): self?.countdown.value = time
            case .isFinished: self?.completeAuction()
            default: break
            }
        })
        timer!.fire()
    }
    
    private func invalidateTimer() {
        if let timer = timer {
            timer.invalidate()
        }
    }
    
    private func completeAuction() {
        submitButtonIsEnabled.value = false
        countdown.value = "Auction has ended"
        invalidateTimer()
        connectBuyerToSeller()
        // remove item stored at different locations for buyer & seller.
        removeItem(userId: AuthService.shared.currentUser.id, resource: .buying, .liked)
        removeItem(userId: item.id, resource: .selling, .all)
        
    }
    
    
    private func connectBuyerToSeller() {
        
        guard let winningBid = maxBid else {
            return
        }
        
        let chatroom = Chatroom(id: NSUUID().uuidString,
                                sellerId: item.ownerId,
                                buyerId: winningBid.ownerId,
                                itemId: item.id,
                                title: item.title,
                                imageUrl: item.imageUrl,
                                lastMessage: "Congrats! Send a message to finalize transaction.",
                                timestamp: Date().timeIntervalSince1970,
                                price: winningBid.dollarAmount)
        
        SaveChatroomTask(data: chatroom.toJSON()).execute(in: dispatcher)
            .materialize()
            .flatMap({ Observable.from(optional: $0.error) })
            .subscribe(onNext: { [weak self] (error) in
                self?.error = Observable.of(error)
            }).disposed(by: disposeBag)
    }
    
    
    private func removeItem(userId: String, resource: ItemResource...) {
        
        let removeTasks = resource.map {
            RemoveItemTask(id: item.id, userId: userId, resource: $0)
                .execute(in: dispatcher)
        }
        
        Observable
            .merge(removeTasks.map({ $0.materialize() }))
            .flatMap({ Observable.from(optional: $0.error) })
            .subscribe(onNext: { [weak self] (error) in
                self?.error = Observable.of(error)
            }).disposed(by: disposeBag)
    }
    
    
    private func updateItem(data: [String: AnyObject], userId: String, resource: ItemResource...) -> Observable<Void> {
        
        let updateTasks: [Observable<Void>] = resource.map {
            UpdateItemTask(data: data, itemId: item.id, userId: userId, resource: $0)
                .execute(in: dispatcher)
        }
        return Observable
            .merge(updateTasks)
    }
    
}






