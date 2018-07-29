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
    
    func login() -> Observable<Bool> {
        unowned let strongSelf = self
        return FirebaseService.shared.createUser(emailText.value, passwordText.value)
            .flatMap { (user) -> Observable<UserModel> in
                return Observable.just(UserModel(uid: user.uid, userName: strongSelf.userNameText.value, email: strongSelf.emailText.value))
            }
            .flatMap({ (userModel) -> Observable<Bool> in
                return FirebaseService.shared.uploadAvatar(strongSelf.imgAvatar.value)
                    .flatMap({ (ref) -> Observable<Bool> in
                        return FirebaseService.shared.getAvatarURL(ref)
                            .map({ (url) -> UserModel in
                                var newUserModel = UserModel(uid: userModel.uid, userName: userModel.userName, email: userModel.email)
                                newUserModel.avatarUrl = url
                                return newUserModel
                            })
                            .flatMap({ (newUserModel) -> Observable<Bool> in
                                return FirebaseService.shared.saveUserToDBS(newUserModel)
                            })
                    })
            })
    }
    
}
