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
        unowned let strongSelf = self        
        FirebaseService.shared.getListData(FirebaseRef.refPost)
            .asObservable()
            .subscribe(onNext: { (snapshot) in
                if let post = snapshot.getPostData() {
                    strongSelf.posts.value.append(post)
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
