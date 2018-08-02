//
//  RegisterViewModel.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 7/28/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import Foundation
import RxSwift

class RegisterViewModel {
    
    var emailText = Variable<String>("")
    var passwordText = Variable<String>("")
    var userNameText = Variable<String>("")
    var imgAvatar = Variable<UIImage>(#imageLiteral(resourceName: "placeholder"))
    let disposeBag = DisposeBag()
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(emailText.asObservable(), passwordText.asObservable(), userNameText.asObservable(), resultSelector: { (email, pass, userName) in
            !email.isEmpty && !pass.isEmpty && !userName.isEmpty
        })
    }
    
    init() {
        
    }
    
    func fetchUserData(_ userModel: UserModel) {
        Parser().fetchDataSignIn(userModel)
    }
    
    func register(with avatar: UIImage) -> Observable<UserModel> {
        unowned let strongSelf = self
        return FirebaseService.shared.createUser(emailText.value, passwordText.value)
            .flatMap { (user) -> Observable<UserModel> in
                return Observable.just(UserModel(uid: user.uid, userName: strongSelf.userNameText.value, email: strongSelf.emailText.value))
            }
            .flatMap({ (userModel) -> Observable<UserModel> in
                return FirebaseService.shared.uploadAvatar(avatar)
                    .flatMap({ (ref) -> Observable<UserModel> in
                        return FirebaseService.shared.getAvatarURL(ref)
                            .map({ (url) -> UserModel in
                                var newUserModel = UserModel(uid: userModel.uid, userName: userModel.userName, email: userModel.email)
                                newUserModel.avatarUrl = url
                                return newUserModel
                            })
                            .flatMap({ (newUserModel) -> Observable<UserModel> in
                                return FirebaseService.shared.saveUserToDBS(newUserModel)
                            })
                    })
            })
            .flatMap({ (userModel) -> Observable<UserModel> in
                return FirebaseService.shared.login(with: userModel.email, strongSelf.passwordText.value)
            })
            .map({$0.uid})
            .flatMap({ (uid) -> Observable<UserModel> in
                return FirebaseService.shared.getUserModel(with: uid)
            })
    }
    
}
