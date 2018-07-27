//
//  ProgressView.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 7/27/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class ProgressView{
    
    static let shared = ProgressView()
    var indicator = NVActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 60,height: 60))
    var containerView = UIView()
    
    func show(_ view: UIView){
        
        containerView.frame = view.frame
        containerView.center = view.center
        containerView.backgroundColor = UIColor(white: 0x000000, alpha: 0.4)
        //        containerView.backgroundColor = UIColor.clear
        
        indicator.type = .ballClipRotate
        indicator.color = .gray
        indicator.center = CGPoint(x: view.bounds.width/2,y: view.bounds.height/2)
        indicator.startAnimating()
        containerView.addSubview(indicator)
        
        view.addSubview(containerView)
    }
    
    func hide(){
        indicator.stopAnimating()
        containerView.removeFromSuperview()
    }
    
}
