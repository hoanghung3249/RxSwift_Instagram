//
//  CameraViewModel.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 8/4/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseAuth

class CameraViewModel {
    
    var statusText = Variable<String>("")
    var imgStatus = Variable<UIImage?>(nil)
    var isValid: Observable<Bool> {
        return Observable.combineLatest(statusText.asObservable(), imgStatus.asObservable(), resultSelector: { (status, img) in
            !status.isEmpty && img != nil
        })
    }
    let disposeBag = DisposeBag()
    
    var userModel: Variable<UserModel?> = Variable<UserModel?>(nil)
    
    init() {
        getUserData()
    }
    
    func uploadStatus(with img: UIImage, and status: String) -> Observable<Bool> {
        unowned let strongSelf = self
        var imageName = ""
        var imgUrl = ""
        return FirebaseService.shared.uploadImage(img)
            .flatMap { (arg) -> Observable<String> in
                let (storage, imgName) = arg
                imageName = imgName
                return FirebaseService.shared.getAvatarURL(storage)
            }
            .flatMap { (url) -> Observable<Bool> in
                imgUrl = url
                let data: [String: Any?] = [
                    "url": url,
                    "uid": Auth.auth().currentUser?.uid,
                    "userName": strongSelf.userModel.value?.userName,
                    "status": status,
                    "urlAvatar": strongSelf.userModel.value?.avatarUrl
                ]
                return FirebaseService.shared.uploadData(tableName: DBSTableName.post, child: nil, value: data)
            }
            .flatMap { (isSuccess) -> Observable<Bool> in
                let value: [String: Any?] = [
                    "urlString": imgUrl
                ]
                return FirebaseService.shared.uploadDataUser(imageName, value: value)
        }
    }
    
}

extension CameraViewModel: UserData {
    
    func getUserData() {
        FirebaseService.shared.getDataUser()
            .asObservable()
            .bind(to: userModel)
            .disposed(by: disposeBag)
    }
    
}
