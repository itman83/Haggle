//
//  AddItemViewModel.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/17/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//
//
//

import Foundation
import RxSwift


class AddItemViewModel {
    

    private let dispatcher: Dispatcher
    private let disposeBag = DisposeBag()
    
    var error: Observable<Error>?
    
    init(dispatcher: Dispatcher) {
        self.dispatcher = dispatcher 
    }
    
    
    func addItem(with info: (title: String?, price: String?, tags: String?, info: String?, weeks: Int, image: UIImage?)) {
        
        // create item from info & url from uploaded image.
        
        var item: Observable<Item> {
            
            if let title = info.title,
                let priceAsString = info.price,
                let price = Int(priceAsString),
                let tags = info.tags,
                let itemInfo = info.info,
                let weeks = Weeks(rawValue: info.weeks),
                let expirationDate = weeks.timeInterval,
                let image = info.image,
                let imageData = UIImageJPEGRepresentation(image, 0.8) {
                
                let imageUrl = ImageAPI.uploadImage(data: imageData, type: .item)
                return imageUrl.flatMapLatest { url -> Observable<Item> in
                    let tagsArray = tags.components(separatedBy: ",") as NSArray
                    let currentUser = AuthService.shared.currentUser
                    let id = NSUUID().uuidString
                    let ownerId = currentUser.id
                    let ownerRating = currentUser.rating
                    let ownerName = currentUser.name
                    let ownerProfileImageUrl = currentUser.profileImageUrl
                    let creationDate = Date().timeIntervalSince1970 as Double
                    let bidCount = 0
                    let location = currentUser.location
                    
                    let newItem = Item(id: id, ownerId: ownerId, ownerRating: ownerRating, ownerName: ownerName, ownerProfileImageUrl: ownerProfileImageUrl, creationDate: creationDate, expirationDate: expirationDate, title: title, price: price, info: itemInfo, imageUrl: url, bidCount: bidCount, tags: tagsArray, location: location)
                    
                    return Observable.of(newItem)
                }
            } else {
                // form is incomplete, show more accurate error description here.
                return Observable.error(CustomError.invalidItem)
            }
        }
        
        item.flatMap { item -> Observable<Void> in
            return SaveItemTask(data: item.toJSON(), resource: .all).execute(in: self.dispatcher)
            }
            .subscribe { event in
                switch event {
                case .error(let error):
                    print("Debugger: error -> \(error.localizedDescription)")
                
                default: break
                }
        }.addDisposableTo(disposeBag)
    
 
    }
    
    
    private func saveItem(data: [String: AnyObject], at locations: ItemResource...) -> Observable<Event<Void>> {

        let saveTasks: [Observable<Void>] = locations.map {
            SaveItemTask(data: data, resource: $0).execute(in: self.dispatcher)
        }
        return Observable
            .merge(saveTasks.map({ $0.materialize() }))
    }
    
    
}















