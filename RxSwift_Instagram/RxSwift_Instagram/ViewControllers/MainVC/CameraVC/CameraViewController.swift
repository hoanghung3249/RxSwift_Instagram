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
        
        txvStatus.rx.didBeginEditing.asObservable()
            .subscribe(onNext: { (_) in
                if strongSelf.txvStatus.text == "What are you thinking?" {
                    strongSelf.txvStatus.text = ""
                    strongSelf.txvStatus.textColor = UIColor.black
                }
            }).disposed(by: disposeBag)
        
        txvStatus.rx.didEndEditing.asObservable()
            .subscribe(onNext: { (_) in
                if strongSelf.txvStatus.text == "" {
                    strongSelf.txvStatus.text = "What are you thinking?"
                    strongSelf.txvStatus.textColor = UIColor.gray
                }
            }).disposed(by: disposeBag)
        
        imgStatus.rx.tapGesture().when(.recognized)
            .subscribe(onNext: { (_) in
                strongSelf.showImagePicker()
            }).disposed(by: disposeBag)
        
        choosePhotoVariable.asDriver().drive(imgStatus.rx.image).disposed(by: disposeBag)
        choosePhotoVariable.asObservable().bind(to: cameraViewModel.imgStatus).disposed(by: disposeBag)
        
        btnShare.rx.tap.asObservable().debounce(0.2, scheduler: MainScheduler.instance)
            .do(onNext: { _ in ProgressView.shared.show(strongSelf.view) })
            .flatMap({ _ in strongSelf.cameraViewModel.uploadStatus(with: strongSelf.imgStatus.image!, and: strongSelf.cameraViewModel.statusText.value) })
            .subscribe(onNext: { (isSuccess) in
                ProgressView.shared.hide()
                strongSelf.reloadUI()
                strongSelf.tabBarController?.selectedIndex = 0
            }, onError: { (error) in
                ProgressView.shared.hide()
                strongSelf.showAlert(with: error.localizedDescription)
            }).disposed(by: disposeBag)
        
    }
    
    private func showImagePicker() {
        let ypImgPicker = YPImagePicker()
        ypImgPicker.didFinishPicking(completion: { [weak self] (items, _) in
            guard let strongSelf = self else { return }
            if let photo = items.singlePhoto {
                strongSelf.choosePhotoVariable.accept(photo.image)
            }
            ypImgPicker.dismiss(animated: true, completion: nil)
        })
        present(ypImgPicker, animated: true, completion: nil)
    }
    
    private func reloadUI() {
        imgStatus.image = #imageLiteral(resourceName: "placeholder")
        txvStatus.text = "What are you thinking?"
    }

}
