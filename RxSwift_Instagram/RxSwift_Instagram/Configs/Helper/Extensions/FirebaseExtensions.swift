//
//  FirebaseExtensions.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 10/28/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper

extension DataSnapshot {
    
    func getPostData() -> Post? {
        if let value = self.value as? [String: Any] {
            var post = Post(JSON: value)
            post?.id = self.key
            let isLiked = post?.likes[(Auth.auth().currentUser?.uid)!] != nil
            post?.isLiked = isLiked
            return post
        }
        return nil
    }
    
    func getData<T: Mappable>() -> T? {
        guard let value = value as? [String: Any] else { return nil }
        var object = T(JSON: value)
        if value.contains(where: {$0.key == "status"}) {
            
        }
        
        return object
    }
}
