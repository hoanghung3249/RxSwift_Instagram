//
//  UIExtensions.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 7/27/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import Foundation
import UIKit

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[.foregroundColor: newValue!])
        }
    }
    
    
    @IBInspectable var paddingLeftCustom: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    @IBInspectable var paddingRightCustom: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
}

extension UIViewController {
    
    func showAlert(with messages: String) {
        let alert = UIAlertController(title: "THÔNG BÁO", message: messages, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertSuccess(with messages: String) {
        let alert = UIAlertController(title: "THÔNG BÁO", message: messages, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithAction(_ title:String,_ mess:String,_ confirmBtn:String?, completion:@escaping (_ bool:Bool)->()) {
        let alert = UIAlertController(title: title, message: mess, preferredStyle: .alert)
        if let confirmBtn = confirmBtn {
            let ok = UIAlertAction(title: confirmBtn, style: .default, handler: { (action) in
                completion(true)
            })
            alert.addAction(ok)
        } else {
            let cancel = UIAlertAction(title: "OK", style: .cancel) { (action) in
                completion(false)
            }
            alert.addAction(cancel)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - PRESENT VC
    func addChildView(_ storyboardName: String, identifier: String) -> UIViewController{
        let vc = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: identifier)
        self.addChildViewController(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        return vc
    }
    
    func pushTo(_ vc: UIViewController){
        let transition = TransitionManager.sharedInstance
        transition.isPresentOnBackButton = false
        vc.transitioningDelegate = transition
        self.present(vc, animated: true, completion: nil)
    }
    
    func popFrom(_ vc: UIViewController){
        let transition = TransitionManager.sharedInstance
        transition.isPresentOnBackButton = true
        vc.transitioningDelegate = transition
        self.present(vc, animated: true, completion: nil)
    }
    
    func rootVC() -> UIViewController{
        return UIApplication.shared.keyWindow!.rootViewController!
    }
    
    //MARK: - HIDE KEYBOARD
    
    func tapToHideKeyboard(){
        let tapOutside = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        self.view.addGestureRecognizer(tapOutside)
    }
    
    @objc func tap(_ gesture: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
}
