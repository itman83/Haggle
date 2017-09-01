//
//  LoginViewController.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/31/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loginButton.rx.tap.asObservable()
            .flatMap { [unowned self] _ -> Observable<Void> in
            return AuthService.shared.rx_authenticate(viewController: self)
            }.subscribe { [weak self] event in
                switch event {
                case .error(let error): print(error.localizedDescription) 
                case .completed: self?.performSegue(withIdentifier: "LoginVC_SearchVC", sender: self)
                default: break
                }
        }.addDisposableTo(disposeBag)
        
    }
    
    
    
}
