//
//  HomeViewModel.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 8/15/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import Foundation
import RxSwift

protocol HomeViewModelDelegate: class{
    func didUpdatePost(_ post: Post)
}

class HomeViewModel {
    
    var posts = Variable<[Post]>([])
    var postUpdated = Variable<Post?>(nil)
    let disposeBag = DisposeBag()
    weak var delegate: HomeViewModelDelegate?
    
    init() {
        getListPost()
        handleDataChanged()
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
    
    func handleDataChanged() {
        unowned let strongSelf = self
        FirebaseService.shared.dataChange(FirebaseRef.refPost)
            .flatMap { (post) -> Observable<Post> in
                return Observable.just(post)
            }
            .subscribe(onNext: { (post) in
                strongSelf.delegate?.didUpdatePost(post)
            }).disposed(by: disposeBag)
    }
    
    func updateLike(with id: String) {
        if let index = posts.value.index(where: {$0.id == id}) {
            posts.value[index] = postUpdated.value!
            print(posts.value.count)
        }
    }
    
}

extension HomeViewModel: UserData {
    func getUserData() {
        
    }
}
