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
    func getDataUser() -> Observable<UserModel?>
    func createUser(_ email: String, _ password: String) -> Observable<User>
    func saveUserToDBS(_ userModel: UserModel) -> Observable<UserModel>
    func uploadAvatar(_ image: UIImage) -> Observable<(StorageReference)>
    func getAvatarURL(_ ref: StorageReference) -> Observable<String>
    func login(with email: String, _ password: String) -> Observable<UserModel>
    func getUserModel(with uid: String) -> Observable<UserModel>
    func uploadImage(_ image: UIImage) -> Observable<(StorageReference, String)>
    func uploadData(tableName: String, child: String?, value: [String: Any?]) -> Observable<Bool>
    func uploadDataUser(_ imgName: String, value: [String: Any?]) -> Observable<Bool>
    func getListPost() -> Observable<[Post]>
}

struct FirebaseService: FirebaseMethod {
    static let shared = FirebaseService()
    
    func getDataUser() -> Observable<UserModel?> {
        return Observable.deferred({ () -> Observable<UserModel?> in
            return Observable.create({ (observer) -> Disposable in
                if let currentUser = Auth.auth().currentUser {
                    FirebaseRef.refUser.child(currentUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let value = snapshot.value as? [String: Any] {
                            let userModel = UserModel(JSON: value)
                            observer.onNext(userModel)
                            observer.onCompleted()
                        }
                    }, withCancel: { (error) in
                        observer.onError(error)
                    })
                } else {
                    observer.onError(ErrorResponse.canNotGetUser)
                }
                return Disposables.create()
            })
        })
    }
    
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
    
    func getUserModel(with uid: String) -> Observable<UserModel> {
        return Observable.deferred({ () -> Observable<UserModel> in
            return Observable.create({ (observer) -> Disposable in
                FirebaseRef.refUser.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let value = snapshot.value as? [String: Any], let userModel = UserModel(JSON: value) {
                        observer.onNext(userModel)
                        observer.onCompleted()
                    } else {
                        observer.onError(ErrorResponse.noData)
                    }
                }, withCancel: { (error) in
                    observer.onError(error)
                })
                return Disposables.create()
            })
        })
    }
    
    func uploadImage(_ image: UIImage) -> Observable<(StorageReference, String)> {
        return Observable.deferred({ () -> Observable<(StorageReference, String)> in
            return Observable.create({ (observer) -> Disposable in
                if let imageData = UIImageJPEGRepresentation(image, 0.1) {
                    let imgName = UUID().uuidString
                    let name = imgName + ".jpg"
                    let ref = FirebaseRef.storage.child("/ImagePost")
                    let refImgPost = ref.child(name)
                    refImgPost.putData(imageData, metadata: nil, completion: { (metaData, error) in
                        if metaData != nil {
                            observer.onNext((refImgPost, imgName))
                            observer.onCompleted()
                        } else if let error = error {
                            observer.onError(error)
                        }
                    })
                } else {
                    observer.onError(ErrorResponse.cannotGetImage)
                }
                return Disposables.create()
            })
        })
    }
    
    func uploadData(tableName: String, child: String?, value: [String: Any?]) -> Observable<Bool> {
        return Observable.deferred({ () -> Observable<Bool> in
            return Observable.create({ (observer) -> Disposable in
                if let child = child {
                    
                } else {
                    FirebaseRef.ref.child(tableName).childByAutoId().setValue(value, withCompletionBlock: { (error, data) in
                        if let error = error {
                            observer.onError(error)
                        } else {
                            observer.onNext(true)
                            observer.onCompleted()
                        }
                    })
                }
                return Disposables.create()
            })
        })
    }
    
    func uploadDataUser(_ imgName: String, value: [String: Any?]) -> Observable<Bool> {
        return Observable.deferred({ () -> Observable<Bool> in
            return Observable.create({ (observer) -> Disposable in
                FirebaseRef.refUserPost.child((Auth.auth().currentUser?.uid)!).child(imgName).setValue(value, withCompletionBlock: { (error, data) in
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
    
    func getListPost() -> Observable<[Post]> {
        return Observable.deferred({ () -> Observable<[Post]> in
            return Observable.create({ (observer) -> Disposable in
                FirebaseRef.refPost.observe(.childAdded, with: { (snapshot) in
                    if let value = snapshot.value as? [String: Any] {
                        var posts = [Post]()
                        var post = Post(JSON: value)
                        post?.id = snapshot.key
                        let isLiked = post?.likes[(Auth.auth().currentUser?.uid)!] != nil
                        post?.isLiked = isLiked
                        
                        posts.append(post!)
                        observer.onNext(posts)
                        observer.onCompleted()
                    }
                }, withCancel: { (error) in
                    observer.onError(error)
                })
                return Disposables.create()
            })
        })
    }
}
