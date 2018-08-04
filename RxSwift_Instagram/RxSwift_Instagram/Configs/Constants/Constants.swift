//
//  Constants.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 7/28/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

enum ErrorResponse: Error {
    case noData
    case canNotGetUser
}

struct Storyboard {
    static let authen = UIStoryboard(name: "Authen", bundle: nil)
    static let main = UIStoryboard(name: "Main", bundle: nil)
}

struct FirebaseRef {
    
    static let ref              = Database.database().reference()
    static let refUser          = Database.database().reference().child(DBSTableName.user)
    static let storage          = Storage.storage().reference(forURL: "gs://instagram-53aeb.appspot.com")
    
}

struct DBSTableName {
    static let user             = "User"
}
