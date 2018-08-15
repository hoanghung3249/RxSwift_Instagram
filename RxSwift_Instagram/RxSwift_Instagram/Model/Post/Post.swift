//
//  Post.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 8/15/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import Foundation
import ObjectMapper

struct Post: Mappable {
    
    var id:String = ""
    var status:String = ""
    var uid:String = ""
    var urlStatus:String = ""
    var avatarUrl:String = ""
    var userName:String = ""
    var likeCount: Int?
    var likes: [String: Any] = [:]
    var isLiked: Bool = false
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        status                  <- map["status"]
        uid                     <- map["uid"]
        urlStatus               <- map["url"]
        avatarUrl               <- map["urlAvatar"]
        userName                <- map["userName"]
        likeCount               <- map["likeCount"]
        likes                   <- map["likes"]
    }
}
