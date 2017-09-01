//
//  SearchVC.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/25/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth // Delete when done manual testing
import FirebaseDatabase // Delete when done manual testing
import HMSegmentedControl


class SearchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var segmentedControl: HMSegmentedControl!
    
    var selectedItem: Item!
    
    var viewModel: SearchViewModel {
        return SearchViewModel(dispatcher: FirebaseDispatcher(),
                               segment: self.segmentedControl.rx.selectedIndex,
                               searchText: searchTextField.rx.text.asObservable())
    }
    
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
        let titles = ["FOR YOU", "TRENDING", "LOCAL", "RECENTLY ADDED"]
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
                self.performSegue(withIdentifier: "SearchVC_ItemDetailVC", sender: self)
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
        
        if segue.identifier == "SearchVC_ItemDetailVC" {
            
            guard let itemDetailVC = segue.destination as? ItemDetailViewController else {
                return
            }
            
            let vm = ItemDetailViewModel(dispatcher: FirebaseDispatcher(), item: selectedItem)
            itemDetailVC.viewModel = vm
        }
    }
    

}





extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
    

}











