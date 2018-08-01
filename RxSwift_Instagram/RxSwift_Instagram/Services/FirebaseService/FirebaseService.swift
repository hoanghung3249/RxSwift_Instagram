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
    func saveUserToDBS(_ userModel: UserModel) -> Observable<UserModel>
    func uploadAvatar(_ image: UIImage) -> Observable<(StorageReference)>
    func getAvatarURL(_ ref: StorageReference) -> Observable<String>
    func login(with email: String, _ password: String) -> Observable<UserModel>
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
                    refAvatar.putData(imgData, metadata: nil, completion: { (metaData, error) in
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
    
    func saveUserToDBS(_ userModel: UserModel) -> Observable<UserModel> {
        return Observable.deferred({ () -> Observable<UserModel> in
            return Observable.create({ (observer) -> Disposable in
                let ref = FirebaseRef.refUser.child(userModel.uid)
                ref.setValue(userModel.toJSON(), withCompletionBlock: { (error, dataRef) in
                    if let error = error {
                        observer.onError(error)
                    } else {
                        observer.onNext(userModel)
                        observer.onCompleted()
                    }
                })
                return Disposables.create()
            })
        })
    }
    
    func login(with email: String, _ password: String) -> Observable<UserModel> {
        return Observable.deferred({ () -> Observable<UserModel> in
            return Observable.create({ (observer) -> Disposable in
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if let user = user {
                        let userModel = UserModel(uid: user.user.uid, userName: user.user.displayName ?? "", email: user.user.email ?? "")
                        observer.onNext(userModel)
                        observer.onCompleted()
                    } else if let error = error {
                        observer.onError(error)
                    }
                })
                return Disposables.create()
            })
        })
    }
}
