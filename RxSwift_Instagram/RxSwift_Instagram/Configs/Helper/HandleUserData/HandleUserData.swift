//
//  HandleUserData.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 8/1/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import Foundation

class HandleUserData {
    
    static let shared = HandleUserData()
    
    func saveUserData(_ userDic: [String: Any]) {
        let userDefault = UserDefaults.standard
        
        if userDefault.value(forKey: "setUserData") != nil{
            userDefault.removeObject(forKey: "setUserData")
        }
        let userData = NSKeyedArchiver.archivedData(withRootObject: userDic)
        userDefault.set(userData, forKey: "setUserData")
        userDefault.synchronize()
    }
    
    func removeUserData() {
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: "setUserData")
        userDefault.synchronize()
    }
    
    func getUserData() -> [String: Any]?{
        let userDefault = UserDefaults.standard
        if let userData = userDefault.value(forKey: "setUserData") as? Data{
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: userData) as? [String: Any]
//            USER?.parseUserData(userInfo!)
            return userInfo
        }
        return nil
    }
    
}
