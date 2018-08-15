//
//  HomeViewModel.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 8/15/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import Foundation
import RxSwift

class HomeViewModel {
    
    var post = Variable<[Post]>([])
    let disposeBag = DisposeBag()
    
    init() {
        getListPost()
    }
    
    
    private func getListPost() {
        FirebaseService.shared.getListPost()
            .asObservable()
            .subscribe(onNext: { [weak self] (arrPost) in
                for p in arrPost {
                    self?.post.value.append(p)
                }
            }).disposed(by: disposeBag)
    }
    
}

extension HomeViewModel: UserData {
    func getUserData() {
        
    }
}
