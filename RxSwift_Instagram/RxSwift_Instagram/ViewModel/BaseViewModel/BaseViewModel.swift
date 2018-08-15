//
//  BaseViewModel.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 8/10/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import Foundation
import RxSwift

class BaseViewModel {
    
    var userModel: Variable<UserModel>?
    let disposeBag = DisposeBag()
    
    init() {
        getUserModel()
    }
    
    private func getUserModel() {
        unowned let strongSelf = self
        FirebaseService.shared.getDataUser().asObservable()
            .subscribe(onNext: { (user) in
                if let user = user {
                    strongSelf.userModel?.value = user
                }
            }).disposed(by: disposeBag)
    }
    
}
