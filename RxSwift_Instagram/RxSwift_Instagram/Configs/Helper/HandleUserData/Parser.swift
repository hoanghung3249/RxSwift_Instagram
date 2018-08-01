//
//  Parser.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 8/1/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import Foundation

class Parser {
    
    func fetchDataSignIn(_ userModel: UserModel) {
        HandleUserData.shared.saveUserData(userModel.toJSON())
    }
    
}
