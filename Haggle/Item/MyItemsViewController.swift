//
//  MyItemsViewController.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/18/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import UIKit
import HMSegmentedControl
import RxSwift
import RxCocoa

class MyItemsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var segmentedControl: HMSegmentedControl!

    var selectedItem: Item?
    
    lazy var viewModel: MyItemsViewModel = {
        
        return MyItemsViewModel(dispatcher: FirebaseDispatcher(),
                                segment: self.segmentedControl.rx.selectedIndex,
                                searchText: self.searchTextField.rx.text.asObservable())
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTextField.delegate = self
        prepareSegmentedControl()
        populateCollectionView()
        prepareActionWhenCollectionViewCellTapped()
        prepareActionWhenErrorOccurs()
        
    }
    
    func prepareSegmentedControl() {
        let titles = ["BUYING", "SELLING", "LIKED"]
        segmentedControl.prepareUI(titles: titles)
    }
    
    func populateCollectionView() {
        
        viewModel.collectionItems.asObservable()
            .observeOn(MainScheduler.instance) 
            .bind(to: collectionView.rx.items(cellIdentifier: "cell", cellType: ItemCell.self))
            { index, item, cell  in
                let vm = ItemCellViewModel(item: item)
                cell.prepare(with: vm)
            }.addDisposableTo(disposeBag)
    }
    
    
    func prepareActionWhenCollectionViewCellTapped() {
        
        collectionView.rx.modelSelected(Item.self)
            .subscribe(onNext: { [unowned self] item in
                self.selectedItem = item
                self.performSegue(withIdentifier: "MyItemsVC_ItemDetailVC", sender: self)
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
        
        if segue.identifier == "MyItemsVC_ItemDetailVC" {
            let itemDetailVC = segue.destination as! ItemDetailViewController
            if let selectedItem = selectedItem {
                itemDetailVC.viewModel = ItemDetailViewModel(dispatcher: FirebaseDispatcher(), item: selectedItem)
            }
        }
    }
    
    
    
}



extension MyItemsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
    
    
}
