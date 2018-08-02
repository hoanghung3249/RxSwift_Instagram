//
//  ViewController.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 7/27/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import UIKit
import Pastel
import RxSwift

class SignInViewController: BaseViewController {
    
    // MARK: - Outlets and Variables
    
    @IBOutlet weak var vwGradient: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogIn: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    let signInViewModel = SignInViewModel()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let user = UserModel.shared
        print(user.email)
    }
    
    
    //MARK: - Support functions
    
    private func setupUI() {
        setupPastelView()
        
        txtEmail.layer.cornerRadius = 10
        txtEmail.layer.backgroundColor = UIColor.clear.cgColor
        txtEmail.layer.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.1).cgColor
        
        txtPassword.layer.cornerRadius = 10
        txtPassword.layer.backgroundColor = UIColor.clear.cgColor
        txtPassword.layer.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.1).cgColor
        
        btnLogIn.layer.cornerRadius = 5
        btnRegister.layer.cornerRadius = 5
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
        
        txtEmail.rx.text.asDriver()
            .map({$0 ?? ""})
            .drive(signInViewModel.emailText)
            .disposed(by: disposeBag)
        
        txtPassword.rx.text.asDriver()
            .map({$0 ?? ""})
            .drive(signInViewModel.passwordText)
            .disposed(by: disposeBag)
        
        signInViewModel.isValid.bind(to: btnLogIn.rx.isEnabled).disposed(by: disposeBag)
        
        btnRegister.rx.tap.asObservable().debounce(0.1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                let registerVC = Storyboard.authen.instantiateViewController(ofType: RegisterViewController.self)
                strongSelf.pushTo(registerVC)
            }).disposed(by: disposeBag)
        
        btnLogIn.rx.tap.asObservable().debounce(0.1, scheduler: MainScheduler.instance)
            .do(onNext: { _ in ProgressView.shared.show(strongSelf.view) })
            .flatMap({ _ in strongSelf.signInViewModel.logIn() })
            .subscribe(onNext: { (userModel) in
                ProgressView.shared.hide()
                strongSelf.signInViewModel.fetchUserData(userModel)
            }, onError: { (error) in
                ProgressView.shared.hide()
                strongSelf.showAlert(with: error.localizedDescription)
            }).disposed(by: disposeBag)
    }

}
