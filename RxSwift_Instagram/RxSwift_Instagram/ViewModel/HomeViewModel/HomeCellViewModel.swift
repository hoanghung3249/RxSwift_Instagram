//
//  HomeCellViewModel.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 8/20/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

class HomeCellViewModel {
    
    var post: Variable<Post?> = Variable<Post?>(nil)
    
    init() {
        
    }
    
    func handleLike(_ ref: DatabaseReference) -> Observable<Post> {
        return FirebaseService.shared.handleLike(ref)
    }
    
}
