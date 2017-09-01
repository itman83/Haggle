//
//  ChatroomViewController.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/24/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import UIKit
import RxSwift


class ChatroomViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var optionsBarButton: UIBarButtonItem!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var starButton0: UIButton!
    @IBOutlet weak var starButton1: UIButton!
    @IBOutlet weak var starButton2: UIButton!
    @IBOutlet weak var starButton3: UIButton!
    @IBOutlet weak var starButton4: UIButton!
    @IBOutlet weak var containerViewBottomLayoutConstraint: NSLayoutConstraint!
    
    var viewModel: ChatroomViewModel!
    
    private let disposeBag = DisposeBag()
    private let dataSource = ChatroomDataSource()
    
    
    override func viewDidLoad() {
        
        tableView.dataSource = dataSource
        textField.delegate = self
        
        populateTableView()
        prepareActionWhenSendMessageButtonTapped()
        prepareActionWhenOptionsButtonTapped()
        prepareActionWhenErrorOccurs()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func addRatingButtonTapped(sender: UIButton) {
        
        var rating = 0
        
        switch sender.tag {
            
        case starButton0.tag:
            setButtonImage(buttons: self.starButton0)
            rating = 1
            
        case starButton1.tag:
            self.setButtonImage(buttons: self.starButton0, self.starButton1)
            rating = 2
            
        case starButton2.tag:
            self.setButtonImage(buttons: self.starButton0, self.starButton1, self.starButton2)
            rating = 3
            
        case starButton3.tag:
            self.setButtonImage(buttons: self.starButton0, self.starButton1, self.starButton2, self.starButton3)
            rating = 4
            
        case starButton4.tag:
            self.setButtonImage(buttons: self.starButton0, self.starButton1, self.starButton2, self.starButton3, self.starButton4)
            rating = 5
            
        default: break
        }
        
        blurView.alpha = 0
        viewModel.updateUserRatings(with: rating)
    }
    
    
    private func setButtonImage(buttons: UIButton...) {
        for button in buttons {
            button.setImage(#imageLiteral(resourceName: "starFilled"), for: .normal)
        }
    }

    
    private func populateTableView() {
        
        viewModel.messages
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] messages in
                self?.dataSource.update(with: messages)
                self?.tableView.reloadData()
            }).addDisposableTo(disposeBag)
    }
    
    
    private func prepareActionWhenSendMessageButtonTapped() {
        
        sendButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                self.viewModel.sendMessage(text: self.textField.text)
                self.textField.text = ""
                self.textField.resignFirstResponder()
            }).addDisposableTo(disposeBag)
    }
    
    
    private func prepareActionWhenOptionsButtonTapped() {
        
        optionsBarButton.rx.tap
            .asObservable()
            .subscribe(onNext: {
                
                let alertController = UIAlertController(title: "Options", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
                
                let ratingAction = UIAlertAction(title: "Submit Rating", style: .default) { (result : UIAlertAction) -> Void in
                    self.blurView.alpha = 1
                }
                
                let deleteAction = UIAlertAction(title: "Delete", style: .default) { (result : UIAlertAction) -> Void in
                    self.viewModel.removeChatroom()
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                
                alertController.addAction(ratingAction)
                alertController.addAction(deleteAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            }).addDisposableTo(disposeBag)
    }
    
    
    func prepareActionWhenErrorOccurs() {
        
        if let error = viewModel.error {
            error.subscribe(onNext: { error in
                print("Debugger: error -> \(error.localizedDescription)")
            }).addDisposableTo(disposeBag)
        }
        
    }
    
}


extension ChatroomViewController {
    
    // Notification Center Selectors
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            if let tabController = self.tabBarController {
                let tabBarHeight = tabController.tabBar.frame.size.height
                self.containerViewBottomLayoutConstraint.constant = keyboardHeight - tabBarHeight
            } else {
                self.containerViewBottomLayoutConstraint.constant = keyboardHeight
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        containerViewBottomLayoutConstraint.constant = 0
    }
    
}



extension ChatroomViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}




