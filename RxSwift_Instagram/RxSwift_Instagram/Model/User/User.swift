//
//  User.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 7/28/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserModel: Mappable {
    static let shared = UserModel()
    
    var uid:String = ""
    var userName:String = ""
    var email:String = ""
    var avatarUrl:String = ""
    var gender:String = ""
    var phoneNumber:String = ""
    
    
    init?(map: Map) {}
    
    init() {
        
    }
    
    mutating func mapping(map: Map) {
        uid         <- map["uid"]
        userName    <- map["userName"]
        email       <- map["email"]
        avatarUrl   <- map["avatarUrl"]
        gender      <- map["gender"]
        phoneNumber <- map["phoneNumber"]
    }
    
    init(uid: String, userName: String, email: String) {
        self.uid = uid
        self.userName = userName
        self.email = email
    }
    
    mutating func logOut() {
        uid = ""
        userName = ""
        email = ""
        avatarUrl = ""
        gender = ""
        phoneNumber = ""
        HandleUserData.shared.removeUserData()
    }
    
    
}
