
//  InboxViewController.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/23/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import UIKit
import HMSegmentedControl
import RxSwift
import RxCocoa


class InboxViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: HMSegmentedControl!
    
    var selectedChatroom: Chatroom!
    private let disposeBag = DisposeBag()
    
    var viewModel: InboxViewModel {
        return InboxViewModel(dispatcher: FirebaseDispatcher(),
                              segment: self.segmentedControl.rx.selectedIndex)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareSegmentedControl()
        populateCollectionView()
        prepareActionWhenCollectionViewTapped()
        prepareActionWhenErrorOccurs()
    }

    private func prepareSegmentedControl() {
        let titles = ["SOLD", "BOUGHT"]
        segmentedControl.prepareUI(titles: titles)
    }
    
    
    func populateCollectionView() {
        
        viewModel.chatrooms
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: InboxCell.self))
            { index, chatroom, cell  in
                let vm = InboxCellViewModel(chatroom)
                cell.prepare(with: vm)
            }.addDisposableTo(disposeBag)
    }
    
    
    func prepareActionWhenCollectionViewTapped() {
        
        tableView.rx.modelSelected(Chatroom.self)
            .subscribe(onNext: { [unowned self] chatroom in
                self.selectedChatroom = chatroom
                self.performSegue(withIdentifier: "InboxVC_ChatroomVC", sender: self)
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
        
        if segue.identifier == "InboxVC_ChatroomVC" {
            let chatroomVC = segue.destination as! ChatroomViewController
            chatroomVC.viewModel = ChatroomViewModel(dispatcher: FirebaseDispatcher(),
                                                     chatroom: selectedChatroom)
        }
    }

    
    
}










