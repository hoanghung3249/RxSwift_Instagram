//
//  CameraViewModel.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 8/4/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import Foundation
import RxSwift

class CameraViewModel {
    
    var statusText = Variable<String>("")
    var imgStatus = Variable<UIImage?>(nil)
    var isValid: Observable<Bool> {
        return Observable.combineLatest(statusText.asObservable(), imgStatus.asObservable(), resultSelector: { (status, img) in
            !status.isEmpty && img != nil
        })
    }
    
    init() {
        
    }
    
}
