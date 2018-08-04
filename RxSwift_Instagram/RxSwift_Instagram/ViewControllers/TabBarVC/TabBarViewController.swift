//
//  TabBarViewController.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 7/27/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TabBarViewController: UITabBarController {
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
    }
    
    // MARK: - Support functions
    
    private func setupViewControllers() {
        let homeVC = Storyboard.main.instantiateViewController(ofType: HomeViewController.self)
        let navHomeVC = UINavigationController(rootViewController: homeVC)
        navHomeVC.navigationBar.isTranslucent = false
        navHomeVC.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "Home"), selectedImage: #imageLiteral(resourceName: "Home_Selected"))
        
        
        self.viewControllers = [navHomeVC]
    }

}
