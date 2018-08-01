//
//  BaseViewController.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 7/27/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let choosePhotoVariable = BehaviorRelay<UIImage?>(value: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        print("Deinit \(self)")
    }
    
}
//Handle select image
extension BaseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImageSelectionAlert() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .alert)
//        alert.modalPresentationStyle = .popover
//        alert.popoverPresentationController?.sourceView = sourceView ?? self.view
//        alert.popoverPresentationController?.sourceRect = sourceView?.bounds ?? self.view.bounds
        let picker = UIImagePickerController()
        picker.delegate = self
        //        picker.allowsEditing = false
        let chooseImage = UIAlertAction(title: "Select from Photos", style: .default) { [weak self](_) in
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self?.present(picker, animated: true, completion: nil)
        }
        let takeFromCam = UIAlertAction(title: "Take from Camera", style: .default) { [weak self](_) in
            picker.sourceType = UIImagePickerControllerSourceType.camera
            self?.present(picker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(chooseImage)
        alert.addAction(takeFromCam)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        choosePhotoVariable.accept(image)
        picker.dismiss(animated: true, completion: nil)
    }
}
