//
//  ItemDetailViewModel.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/7/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


class ItemDetailViewModel {
    
    private let dispatcher: Dispatcher
    private let disposeBag = DisposeBag()
    private var didLikeItem = false
    let item: Item

    var price: String { return "$\(item.price)" }
    var bidCount: String { return "\(item.bidCount) bids" }
    var ownerRating: String { return "\(item.ownerRating)" }
    
    var itemImage: Observable<Data> {
        return ImageAPI.downloadImage(urlString: item.imageUrl, type: .item)
    }
    
    var ownerImage: Observable<Data> {
        return ImageAPI.downloadImage(urlString: item.ownerProfileImageUrl, type: .user)
    }
    
    var likeButtonImage = PublishSubject<UIImage>()
    var error: Observable<Error>?
    
    
    init(dispatcher: Dispatcher, item: Item) {
        self.dispatcher = dispatcher
        self.item = item
    }
    
    
    // TODO: check database to see if user has already liked item first.
    func likeItem() {
        
        if didLikeItem {
            likeButtonImage.onNext(#imageLiteral(resourceName: "like"))
            RemoveItemTask(id: item.id, userId: AuthService.shared.currentUser.id, resource: .liked)
                .execute(in: dispatcher)
                .materialize()
                .flatMap({ Observable.from(optional: $0.error) })
                .subscribe(onNext: { [weak self] (error) in
                    self?.error = Observable.of(error)
                }).disposed(by: disposeBag)
            
        } else {
            likeButtonImage.onNext(#imageLiteral(resourceName: "likeFilled"))
            
            // update tags of currentUser by adding tags from the items they like.
            
            let currentTags = AuthService.shared.currentUser.tags
            let addedTags = self.item.tags
            let updatedTags = currentTags.addingObjects(from: addedTags as! [Any])
            let updateUserTask = UpdateUserTask(data: [Constant.tags: updatedTags as AnyObject], id: AuthService.shared.currentUser.id).execute(in: dispatcher)
            
            let saveItemTask = SaveItemTask(data: item.toJSON(), resource: .liked)
                .execute(in: dispatcher)
        
            Observable.combineLatest(updateUserTask, saveItemTask)
                .materialize()
                .flatMap({ Observable.from(optional: $0.error) })
                .subscribe(onNext: { [weak self] (error) in
                    self?.error = Observable.of(error)
                }).addDisposableTo(disposeBag) 
        }
        
        didLikeItem = !didLikeItem
    }
    
    
}



