//
//  AuthService.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/30/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import UIKit
import RxSwift
import FirebaseDatabase
import FirebaseAuth
import FBSDKLoginKit


class AuthService {

    private static let _shared = AuthService()
    
    static var shared: AuthService {
        return _shared
    }
    
    private let dispatcher = FirebaseDispatcher()
    
    // Authentication is first order of business
    // After successfull authentication, Currently signed in user is accessible through currentUser property.
    private var _currentUser: User!
    
    var currentUser: User {
        return _currentUser
    }
    
    
    func rx_authenticate(viewController: UIViewController) -> Observable<Void> {

        return Observable<Void>.create { observer in

            self.rx_facebookLogin(viewController: viewController)
                .flatMapLatest({ [unowned self] (credential, userInfo) -> Observable<[String: AnyObject]> in
                    self.rx_firebaseLogin(with: credential, userInfo: userInfo as [String : AnyObject])
                })
                .subscribe { event in
                    switch event {
                    case .next(let data):
                        if let user = User(json: data) {
                            self._currentUser = user
                            observer.onCompleted()
                        } else {
                            observer.onError(AuthError.custom(message: "could not intialize user with facebook data."))
                        }
                    case .error(let error): observer.onError(error)
                        
                    default: break
                    }
                }.dispose()
            
            return Disposables.create()
        }
    }
    
    
    private func rx_facebookLogin(viewController: UIViewController) -> Observable<(AuthCredential, [String: Any])> {
        
        return Observable<(AuthCredential, [String: Any])>.create { observer in
            
            let loginManager = FBSDKLoginManager()
            
            loginManager.logIn(withReadPermissions: ["public_profile", "email"], from: viewController) { (result, error) in
            
                guard error == nil else {
                    observer.onError(AuthError.custom(message: error!.localizedDescription))
                    return
                }
                guard let accessToken = FBSDKAccessToken.current() else {
                    observer.onError(AuthError.invalidAccesToken)
                    return
                }
                
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                
                guard let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name, location"], tokenString: accessToken.tokenString, version: nil, httpMethod: "GET") else {
                    observer.onError(AuthError.facebookGraphRequestFailed)
                    return
                }
                
                request.start { (connection, result, error) in
                    
                    guard error == nil else {
                        observer.onError(AuthError.custom(message: error!.localizedDescription))
                        return
                    }
                    guard let result = result as? [String: AnyObject], let name = result[Constant.name] as? String, let location = result[Constant.location] as? String else {
                        observer.onError(AuthError.invalidProfileData)
                        return
                    }
                    
                    // emit data needed to proceed with firebase login process.
                    observer.onNext((credential, [Constant.name: name, Constant.location: location]))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    

    private func rx_firebaseLogin(with credential: AuthCredential, userInfo: [String: AnyObject]) -> Observable<[String: AnyObject]> {
        return Observable<[String: AnyObject]>.create { observer in
            Auth.auth().signIn(with: credential) { (user, error) in
                
                guard error == nil else {
                    observer.onError(AuthError.custom(message: error!.localizedDescription))
                    print(error!.localizedDescription)
                    return
                }
                
                guard user != nil else {
                    observer.onError(AuthError.invalidFirebaseUser)
                    return
                }
                
                // construct user values, with placeholders for empty values. This assures each user maintains correct format for successful initialization when fetched.
                var data = userInfo
                data[Constant.id] = user!.uid as AnyObject
                data[Constant.rating] = 3.0 as AnyObject
                data[Constant.ratings] = [NSUUID().uuidString: 3.0] as AnyObject
                data[Constant.tags] = ["placeholder"] as AnyObject
                data[Constant.profileImageUrl] = "placeolder" as AnyObject
            
                self.signUpUserIfNeeded(with: data)
                    .subscribe(onError: {
                        observer.onError($0)
                    }).dispose()
                
            }
            return Disposables.create()
        }
    }
    
    
    private func signUpUserIfNeeded(with data: [String: AnyObject]) -> Observable<Void> {
        return Observable.create { observer in
            // Use firebase cloud function to check if user already exists.
            Database.database().reference().child(Constant.users).child(data[Constant.id] as! String)
                .observeSingleEvent(of: .value, with: { (snapshot) in
                    if !snapshot.exists() {
                        // New User signing up.
                        SaveUserTask(data: data).execute(in: self.dispatcher)
                            .materialize()
                            .flatMap({ Observable.from(optional: $0.error) })
                            .subscribe(onNext: { (error) in
                               observer.onError(error)
                            }).dispose()
                    }
                    else {
                        observer.onCompleted()
                    }
                })
            return Disposables.create()
        }
    }
    
    
}
