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
    
    var posts = Variable<[Post]>([])
    var postUpdated = Variable<Post?>(nil)
    let disposeBag = DisposeBag()
    
    init() {
        getListPost()
    }
    
    private func getListPost() {
        FirebaseService.shared.getListPost()
            .asObservable()
            .subscribe(onNext: { [weak self] (arrPost) in
                for p in arrPost {
                    self?.posts.value.append(p)
                }
            }).disposed(by: disposeBag)
    }
    
    func updateLike(with id: String) {
        if let index = posts.value.index(where: {$0.id == id}) {
            posts.value[index] = postUpdated.value!
            print(posts.value.count)
        }
    }
    
}
