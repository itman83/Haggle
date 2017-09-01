//
//  AuctionCellViewModel.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/15/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation
import RxSwift



class AuctionCellViewModel {
    
    let image: Observable<Data>
    let name: String
    let price: String
    let info: String
    
    init(row: Int, bid: Bid) {
        name = bid.ownerName
        price = "$\(bid.dollarAmount)"
        image = ImageAPI.downloadImage(urlString: bid.profileImageUrl, type: .user)
        
        if row == 0 {
            info = "Leading bidder"
        } else {
            info = "" 
        }
    }
    
    
}
