//
//  MyAccountViewModel.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/20/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation
import RxSwift

class MyAccountViewModel {
    
    private let dispatcher = FirebaseDispatcher()
    var name: String
    var rating: String
    var image: Observable<Data>
    
    init () {
        name = AuthService.shared.currentUser.name
        rating = "\(AuthService.shared.currentUser.rating)"
        image = ImageAPI.downloadImage(urlString: AuthService.shared.currentUser.profileImageUrl, type: .user)
    }
    
}
