//
//  MyAccountViewController.swift
//  Haggle
//
//  Created by Aamahd Walker on 7/26/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class MyAccountViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    let viewModel: MyAccountViewModel = MyAccountViewModel()
    
    let imagePicker = UIImagePickerController()
    let dataSource = MyAccountDataSource()
    
    var imageViewTapGesture: UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(self.ImageViewTapped(sender:)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        prepareViewForDisplay()
        prepareImagePicker()
    }

    
    private func prepareViewForDisplay() {
        nameLabel.text = viewModel.name
        ratingLabel.text = viewModel.rating
        viewModel.image
            .observeOn(MainScheduler.instance)
            .map { UIImage(data: $0) }
            .bind(to: profileImageView.rx.image)
            .addDisposableTo(disposeBag)
    }

    

}



extension MyAccountViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    // Image Picker Delegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = selectedImage
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // Image View selector
    
    func ImageViewTapped(sender: UIImageView) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            plusImageView.alpha = 0
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    // helpers 
    
    func prepareImageViewGestureRecognizer() {
        profileImageView.addGestureRecognizer(imageViewTapGesture)
        profileImageView.isUserInteractionEnabled = true
    }
    
    func prepareImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }
    
}
