//
//  ItemCellViewModel.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/8/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation
import RxSwift

class ItemCellViewModel {
    
    let title: String
    let price: String
    let rating: String
    var image: Observable<Data>
    
    let disposeBag = DisposeBag()
    
    init(item: Item) {
        self.title = item.title
        self.price = "$\(item.price)"
        self.rating = "\(item.ownerRating)"
        image = ImageAPI.downloadImage(urlString: item.imageUrl, type: .item)

    }
}




