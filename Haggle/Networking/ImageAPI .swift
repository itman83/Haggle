//
//  ImageAPI .swift
//  Haggle
//
//  Created by Aamahd Walker on 8/18/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import Foundation
import FirebaseStorage
import RxSwift


// Describes the type of image being uploaded or downloaded.

enum ImageType {
    case item
    case user
}


// Provides an interface for uploading and downloading images from Firebase Storage.

class ImageAPI {
    
    static func uploadImage(data: Data, type: ImageType) -> Observable<String>{
        
        let url = "gs://haggle-81e4d.appspot.com"
        
        var storageRef = Storage.storage().reference(forURL: url )
        
        switch type {
        case .item: storageRef = storageRef.child(Constant.items).child(AuthService.shared.currentUser.id).child(NSUUID().uuidString)
        case .user: storageRef = storageRef.child(Constant.users).child(AuthService.shared.currentUser.id)
        }
        
        return Observable<String>.create { observer in
            
            storageRef.putData(data, metadata: nil) { (metadata, error) in
                
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                if let metadata = metadata, let url = metadata.downloadURL() {
                    let urlString = url.absoluteString
                    observer.onNext(urlString)
                }
                
                }.resume()
            
            return Disposables.create()
        }
        
    }
    
    static func downloadImage(urlString: String, type: ImageType) -> Observable<Data> {
        
        var imageData: Observable<Data>
        
        switch type {
            
        case .user:
            let data = UIImageJPEGRepresentation(#imageLiteral(resourceName: "defaultUser"), 0.8)!
            imageData = Observable.of(data)
            
        case .item:
            let data = UIImageJPEGRepresentation(#imageLiteral(resourceName: "defaultItem"), 0.8)!
            imageData = Observable.of(data)
        }
        
        guard let url = URL(string: urlString) else {
            return imageData
        }
        
        let request = URLRequest(url: url)
        
        return URLSession.shared.rx.data(request: request)
    }
    
}






