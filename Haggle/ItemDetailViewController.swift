//
//  ItemDetailViewController.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/21/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//



import UIKit
import RxSwift
import RxCocoa

class ItemDetailViewController: UIViewController {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemBidCountLabel: UILabel!
    @IBOutlet weak var ownerProfileImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var ownerRatingLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dismissVCBarButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var viewModel: ItemDetailViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViewForDisplay()
        prepareActionWhenLikeButtonTapped()
        prepareActionWhenDismissVCButtonTapped()
        prepareActionWhenErrorOccurs()
    }
    
    func prepareViewForDisplay() {

        if let topItem = self.navigationBar.topItem {
            topItem.title = viewModel.item.title
        }
        
        ownerNameLabel.text = viewModel.item.ownerName
        itemPriceLabel.text = viewModel.price
        itemBidCountLabel.text = viewModel.bidCount
        ownerRatingLabel.text = viewModel.ownerRating
        
        viewModel.itemImage
            .observeOn(MainScheduler.instance)
            .map { UIImage(data: $0) }
            .bind(to: itemImageView.rx.image)
            .addDisposableTo(disposeBag)
        
        viewModel.ownerImage
            .observeOn(MainScheduler.instance)
            .map { UIImage(data: $0) }
            .bind(to: ownerProfileImageView.rx.image)
            .addDisposableTo(disposeBag)
        
    }
    
    
    func prepareActionWhenLikeButtonTapped() {
        
        likeButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                self.viewModel.likeItem()
            }).addDisposableTo(disposeBag)
        
        
        viewModel.likeButtonImage
            .asObservable()
            .subscribe(onNext: { [weak self] image in
                self?.likeButton.setImage(image, for: .normal)
            }).addDisposableTo(disposeBag)
        
    }
    
    
    func prepareActionWhenDismissVCButtonTapped() {
        
        dismissVCBarButton.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                self.dismiss(animated: true, completion: nil)
            }).addDisposableTo(disposeBag)
    }
    
    
    func prepareActionWhenErrorOccurs() {
        
        if let error = viewModel.error {
            error.subscribe(onNext: { error in
                print("Debugger: error -> \(error.localizedDescription)")
            }).addDisposableTo(disposeBag)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailVC_AuctionRoomVC" {
            let auctionVC = segue.destination as! AuctionViewController
            auctionVC.viewModel = AuctionViewModel(dispatcher: FirebaseDispatcher(), item: viewModel.item)
        }
    }
    
    
    
}



