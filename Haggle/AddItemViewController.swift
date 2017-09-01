//
//  AddItemViewController.swift
//  Haggle
//
//  Created by Aamahd Walker on 8/18/17.
//  Copyright © 2017 Aamahd Walker. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class AddItemViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var tagsTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var weeksSegmentedControl: UISegmentedControl!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var dismissVCBarButton: UIBarButtonItem!
    
    let disposeBag = DisposeBag()
    
    var viewModel: AddItemViewModel {
        return AddItemViewModel(dispatcher: FirebaseDispatcher())
    }
    
    var imageViewTapGesture: UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(self.ImageViewTapped(sender:)))
    }
    
    let imagePicker = UIImagePickerController()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareImageViewGestureRecognizer()
        prepareImagePicker()
        prepareTextFields()
        prepareActionWhenAddItemButtonTapped()
        prepareActionWhenDismissVCButtonTapped()
        prepareActionWhenErrorOccurs()
        
        
        if let error = viewModel.error {
            
            error.subscribe(onNext: { err in
                print("DEBUGGER: error from vc: \(err.localizedDescription)")
            }).addDisposableTo(disposeBag)
            
        }
        
    }


    
    private func prepareActionWhenAddItemButtonTapped() {
        
        addButton.rx.tap
            .asObservable()
            .flatMap {  [weak self] _ -> Observable<(String?, String?, String?, String?, Int, UIImage?)> in
                guard let strongSelf = self else {
                    print("DEBUGGER: strong self nil from button tap.")
                return Observable<(String?, String?, String?, String?, Int, UIImage?)>.empty()
                }
                
                let itemInfo = Observable
                    .combineLatest(strongSelf.titleTextField.rx.text.asObservable(),
                                   strongSelf.priceTextField.rx.text.asObservable(),
                                   strongSelf.tagsTextField.rx.text.asObservable(),
                                   strongSelf.infoTextField.rx.text.asObservable(),
                                   strongSelf.weeksSegmentedControl.rx.selectedSegmentIndex.asObservable(),
                                   strongSelf.imageView.rx.observe(UIImage.self, "image"))
                    { (title, price, tags, info, weeks, image) -> (String?, String?, String?, String?, Int, UIImage?) in
                        return (title, price, tags, info, weeks, image)
                }
                return itemInfo
            }
            .subscribe(onNext: { [weak self] itemInfo in
                self?.viewModel.addItem(with: itemInfo)
                self?.clearForm()
            }).addDisposableTo(disposeBag)
    }
    

    private func clearForm() {
        self.titleTextField.text = ""
        self.priceTextField.text = ""
        self.tagsTextField.text = ""
        self.infoTextField.text = ""
        self.imageView.image = nil
        self.plusImageView.alpha = 1 
    }
    
    
    private func prepareActionWhenDismissVCButtonTapped() {
        
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
    
}


extension AddItemViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // image picker controller delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = selectedImage
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // image view selector
    
    func ImageViewTapped(sender: UIImageView) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            plusImageView.alpha = 0
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    // helpers
    
    func prepareImageViewGestureRecognizer() {
        imageView.addGestureRecognizer(imageViewTapGesture)
        imageView.isUserInteractionEnabled = true
    }
    
    
    func prepareImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }
    
    
    
}



extension AddItemViewController: UITextFieldDelegate {
    
    func prepareTextFields() {
        titleTextField.delegate = self
        tagsTextField.delegate = self
        infoTextField.delegate = self
        priceTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



