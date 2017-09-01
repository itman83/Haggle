//
//  AuctionViewController.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/22/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//



import UIKit
import RxSwift


class AuctionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var bidTextField: UITextField!
    @IBOutlet weak var submitBid: UIButton!
    @IBOutlet weak var dismissVCButton: UIBarButtonItem!
    
    var viewModel: AuctionViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareViewForDisplay()
        populateTableView()
        prepareTextField()
        prepareActionWhenSubmitBidButtonTapped()
        prepareActionWhenErrorOccurs()
        prepareActionWhenDismissVCButtonTapped()
    }
    
    
    func prepareViewForDisplay() {
        
        viewModel.itemImage
            .observeOn(MainScheduler.instance)
            .map { UIImage(data: $0) }
            .bind(to: itemImageView.rx.image)
            .addDisposableTo(disposeBag)
        
        viewModel.countdown
            .asObservable()
            .observeOn(MainScheduler.instance) 
            .bind(to: countdownLabel.rx.text)
            .addDisposableTo(disposeBag)
    }
    
    
    func populateTableView() {
        
        viewModel.bids
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: AuctionCell.self))
        { index, bid, cell  in
            let vm = AuctionCellViewModel(row: index, bid: bid)
            cell.prepare(with: vm)
            }.addDisposableTo(disposeBag)
    }
    
    
    func prepareActionWhenSubmitBidButtonTapped() {
        
        submitBid.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                if let bidAmount = self.bidTextField.text, let amount = Int(bidAmount) {
                    self.viewModel.submitBid(amount: amount)
                }
            }).addDisposableTo(disposeBag)
        
        
        viewModel.submitButtonIsEnabled
            .asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: submitBid.rx.isEnabled)
            .addDisposableTo(disposeBag)
    }
    
    
    func prepareActionWhenErrorOccurs() {
        
        if let error = viewModel.error {
            error.subscribe(onNext: { error in
                print("Debugger: error -> \(error.localizedDescription)")
            }).addDisposableTo(disposeBag)
        }
        
    }
    
    
    
    func prepareActionWhenDismissVCButtonTapped() {
        
        dismissVCButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self] in
               self.dismiss(animated: true, completion: nil)
        }).addDisposableTo(disposeBag)
    }


}



extension AuctionViewController: UITextFieldDelegate {
    
    func prepareTextField() {
        bidTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
    
}




