//
//  SignInViewModel.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 7/28/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import Foundation
import RxSwift

class SignInViewModel {
    
    var emailText = Variable<String>("")
    var passwordText = Variable<String>("")
    var isValid: Observable<Bool> {
        return Observable.combineLatest(emailText.asObservable(), passwordText.asObservable(), resultSelector: { (email, password) in
            !email.isEmpty && !password.isEmpty
        })
    }
    
    init() {
        
    }
    
    func fetchUserData(_ userModel: UserModel) {
        Parser().fetchDataSignIn(userModel)
    }
    
    func logIn() -> Observable<UserModel> {
        return FirebaseService.shared.login(with: emailText.value, passwordText.value)
            .map({$0.uid})
            .flatMap({ (uid) -> Observable<UserModel> in
                return FirebaseService.shared.getUserModel(with: uid)
            })
    }
    
}
