//
//  FirebaseService.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 7/28/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

protocol FirebaseMethod {
    func createUser(_ email: String, _ password: String) -> Observable<User>
    func saveUserToDBS(_ userModel: UserModel) -> Observable<Bool>
    func uploadAvatar(_ image: UIImage) -> Observable<(StorageReference)>
    func getAvatarURL(_ ref: StorageReference) -> Observable<String>
}

struct FirebaseService: FirebaseMethod {
    static let shared = FirebaseService()
    
    func createUser(_ email: String, _ password: String) -> Observable<User> {
        return Observable.deferred { () -> Observable<User> in
            return Observable.create({ (observer) -> Disposable in
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    if let user = user {
                        observer.onNext(user.user)
                        observer.onCompleted()
                    } else if let error = error {
                        observer.onError(error)
                    }
                })
                return Disposables.create()
            })
        }
    }
    
    func uploadAvatar(_ image: UIImage) -> Observable<StorageReference> {
        return Observable.deferred({ () -> Observable<StorageReference> in
            return Observable.create({ (observer) -> Disposable in
                if let imgData = UIImagePNGRepresentation(image) {
                    let imgName = UUID().uuidString
                    let ref = FirebaseRef.storage.child("/Avatar")
                    let refAvatar = ref.child(imgName)
                    ref.putData(imgData, metadata: nil, completion: { (metaData, error) in
                        if metaData != nil {
                            observer.onNext(refAvatar)
                            observer.onCompleted()
                        } else if let error = error {
                            observer.onError(error)
                        }
                    })
                }
                return Disposables.create()
            })
        })
    }
    
    func getAvatarURL(_ ref: StorageReference) -> Observable<String> {
        return Observable.deferred({ () -> Observable<String> in
            return Observable.create({ (observer) -> Disposable in
                ref.downloadURL(completion: { (url, error) in
                    if let url = url {
                        observer.onNext(url.absoluteString)
                        observer.onCompleted()
                    } else if let error = error {
                        observer.onError(error)
                    }
                })
                return Disposables.create()
            })
        })
    }
    
    func saveUserToDBS(_ userModel: UserModel) -> Observable<Bool> {
        return Observable.deferred({ () -> Observable<Bool> in
            return Observable.create({ (observer) -> Disposable in
                let ref = FirebaseRef.refUser.child(userModel.uid)
                ref.setValue(userModel.toJSON(), withCompletionBlock: { (error, dataRef) in
                    if let error = error {
                        observer.onError(error)
                    } else {
                        observer.onNext(true)
                        observer.onCompleted()
                    }
                })
                return Disposables.create()
            })
        })
    }
}
