//
//  RegisterViewController.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 7/28/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import UIKit
import Pastel
import RxCocoa
import RxSwift

class RegisterViewController: BaseViewController {
    
    // MARK: - Outlets and Variables
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var vwGradient: UIView!
    let registerViewModel = RegisterViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindData()
    }

    
    // MARK: - Support functions
    private func setupUI() {
        setupPastelView()
        
        txtEmail.layer.cornerRadius = 10
        txtEmail.layer.backgroundColor = UIColor.clear.cgColor
        txtEmail.layer.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.1).cgColor
        
        txtPassword.layer.cornerRadius = 10
        txtPassword.layer.backgroundColor = UIColor.clear.cgColor
        txtPassword.layer.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.1).cgColor
        
        txtUserName.layer.cornerRadius = 10
        txtUserName.layer.backgroundColor = UIColor.clear.cgColor
        txtUserName.layer.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.1).cgColor
        
        btnRegister.layer.cornerRadius = 5
        
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.width / 2
        imgAvatar.clipsToBounds = true
    }
    
    private func setupPastelView() {
        let pastelView = PastelView(frame: view.bounds)
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 3.0
        
        // Custom Color
        pastelView.setColors([UIColor(red: 138/255, green: 58/255, blue: 185/255, alpha: 1.0),
                              UIColor(red: 76/255, green: 104/255, blue: 215/255, alpha: 1.0),
                              UIColor(red: 205/255, green: 72/255, blue: 107/255, alpha: 1.0),
                              UIColor(red: 251/255, green: 173/255, blue: 80/255, alpha: 1.0),
                              UIColor(red: 252/255, green: 204/255, blue: 99/255, alpha: 1.0),
                              UIColor(red: 188/255, green: 42/255, blue: 141/255, alpha: 1.0),
                              UIColor(red: 233/255, green: 89/255, blue: 80/255, alpha: 1.0)])
        
        pastelView.startAnimation()
        vwGradient.insertSubview(pastelView, at: 0)
    }
    
    private func bindData() {
        unowned let strongSelf = self
        
        txtEmail.rx.text.map{$0 ?? ""}.bind(to: registerViewModel.emailText).disposed(by: disposeBag)
        txtPassword.rx.text.map{$0 ?? ""}.bind(to: registerViewModel.passwordText).disposed(by: disposeBag)
        txtUserName.rx.text.map{$0 ?? ""}.bind(to: registerViewModel.userNameText).disposed(by: disposeBag)
        
        btnBack.rx.tap.subscribe(onNext: {
            strongSelf.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        registerViewModel.isValid.bind(to: btnRegister.rx.isEnabled).disposed(by: disposeBag)
        
        choosePhotoVariable.asObservable()
            .filter({$0 != nil})
            .bind(to: imgAvatar.rx.image)
            .disposed(by: disposeBag)
        
        choosePhotoVariable.asObservable()
            .filter({$0 != nil})
            .map({$0 ?? #imageLiteral(resourceName: "placeholder")})
            .subscribe(onNext: { (image) in
                strongSelf.registerViewModel.imgAvatar.value = image
            }).disposed(by: disposeBag)
        
        imgAvatar.rx.tapGesture().when(.recognized)
            .subscribe(onNext: { (_) in
                strongSelf.showImageSelectionAlert(sourceView: strongSelf.imgAvatar)
            }).disposed(by: disposeBag)
        
        btnRegister.rx.tap.asObservable().debounce(0.2, scheduler: MainScheduler.instance)
            .flatMap({ _ in strongSelf.registerViewModel.login() })
            .subscribe(onNext: { (isSuccess) in
                print(isSuccess)
            }, onError: { (error) in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
        
//        btnRegister.rx.tap
//            .flatMap{ _ in strongSelf.registerViewModel.login() }
//            .asObservable()
//            .subscribe(onNext: { (isSuccess) in
//                print(isSuccess)
//            }, onError: { (error) in
//                print(error.localizedDescription)
//            }).disposed(by: disposeBag)
    }

}
