//
//  CameraViewController.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 8/4/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import UIKit
import RxGesture
import RxSwift
import RxCocoa
import YPImagePicker

class CameraViewController: BaseViewController {
    
    // MARK: - Outlets and Variables
    
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var txvStatus: UITextView!
    @IBOutlet weak var btnShare: UIButton!
    let cameraViewModel = CameraViewModel()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupUI()
        bindData()
    }
    
    // MARK: - Support functions
    private func setupNav() {
        self.navigationController?.navigationBar.titleTextAttributes = [.font: Font.Billabong(30)]
        self.navigationItem.title = "New Post"
    }
    
    private func setupUI() {
        imgStatus.contentMode = .scaleAspectFill
    }
    
    private func bindData() {
        unowned let strongSelf = self
        
        txvStatus.rx.text.asDriver().map({$0 ?? ""}).drive(cameraViewModel.statusText).disposed(by: disposeBag)
        cameraViewModel.isValid.bind(to: btnShare.rx.isEnabled).disposed(by: disposeBag)
        cameraViewModel.imgStatus.asDriver().drive(imgStatus.rx.image).disposed(by: disposeBag)
        
        imgStatus.rx.tapGesture().when(.recognized)
            .subscribe(onNext: { (_) in
                let ypImgPicker = YPImagePicker()
                ypImgPicker.didFinishPicking(completion: { (items, _) in
                    if let photo = items.singlePhoto {
                        strongSelf.choosePhotoVariable.accept(photo.image)
                    }
                    ypImgPicker.dismiss(animated: true, completion: nil)
                })
                strongSelf.present(ypImgPicker, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        choosePhotoVariable.asDriver().drive(imgStatus.rx.image).disposed(by: disposeBag)
        choosePhotoVariable.asObservable().bind(to: cameraViewModel.imgStatus).disposed(by: disposeBag)
        
        btnShare.rx.tap.asObservable()
            .subscribe(onNext: { (_) in
                print("Share the photo")
            }).disposed(by: disposeBag)
    }

}
