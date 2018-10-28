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
import ObjectMapper

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
    func handleLike(_ ref: DatabaseReference) -> Observable<Post>
    func dataChange(_ ref: DatabaseReference) -> Observable<Post>
    func getListData<T: Mappable>(_ ref: DatabaseReference) -> Observable<T>
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
                    var posts = [Post]()
                    if let post = snapshot.getPostData() {
                        posts.append(post)
                        observer.onNext(posts)
//                        observer.onCompleted()
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
    
    func handleLike(_ ref: DatabaseReference) -> Observable<Post> {
        return Observable.deferred { () -> Observable<Post> in
            return Observable.create({ (observer) -> Disposable in
                ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
                    if var post = currentData.value as? [String: Any], let uid = Auth.auth().currentUser?.uid {
                        var likes: [String: Bool]
                        likes = post["likes"] as? [String : Bool] ?? [:]
                        var likeCount = post["likeCount"] as? Int ?? 0
                        if let _ = likes[uid] {
                            // Unlike the post and remove self from stars
                            likeCount -= 1
                            likes.removeValue(forKey: uid)
                        } else {
                            // Like the post and add self to stars
                            likeCount += 1
                            likes[uid] = true
                        }
                        post["likeCount"] = likeCount as AnyObject?
                        post["likes"] = likes as AnyObject?
                        
                        // Set value and report transaction success
                        currentData.value = post
                        
                        return TransactionResult.success(withValue: currentData)
                    }
                    return TransactionResult.success(withValue: currentData)
                }, andCompletionBlock: { (error, committed, snapshot) in
                    if let error = error {
                        observer.onError(error)
                    }
                    
                    if let dic = snapshot?.value as? [String: Any] {
                        var post = Post(JSON: dic)
                        post?.id = (snapshot?.key)!
                        
                        if let currentUserId = Auth.auth().currentUser?.uid {
                            if post?.likes != nil {
                                let isLiked = post?.likes[currentUserId] != nil
                                post?.isLiked = isLiked
                            }
                        }
                        observer.onNext(post!)
                        observer.onCompleted()
                    } else {
                        observer.onError(ErrorResponse.noData)
                    }
                })
                return Disposables.create()
            })
        }
    }
    
    func dataChange(_ ref: DatabaseReference) -> Observable<Post> {
        return Observable.deferred({ () -> Observable<Post> in
            return Observable.create({ (observer) -> Disposable in
                FirebaseRef.refPost.observe(.childChanged, with: { (snapshot) in
                    if let value = snapshot.value as? [String: Any] {
                        var postUpdated = Post(JSON: value)
                        postUpdated?.id = snapshot.key
                        observer.onNext(postUpdated!)
                        observer.onCompleted()
                    }
                }, withCancel: { (error) in
                    observer.onError(error)
                })
                return Disposables.create()
            })
        })
    }
    
    func getListData<T>(_ ref: DatabaseReference) -> Observable<T> {
        return Observable.deferred({ () -> Observable<T> in
            return Observable.create({ (observer) -> Disposable in
                ref.observe(.childAdded, with: { (snapshot) in
                    
                }, withCancel: { (error) in
                    observer.onError(ErrorResponse.noData)
                })
                return Disposables.create()
            })
        })
    }
}
