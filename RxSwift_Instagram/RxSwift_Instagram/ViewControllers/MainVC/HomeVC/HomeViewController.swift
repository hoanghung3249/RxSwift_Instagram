//
//  HomeViewController.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 8/4/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    // MARK: - Outlets and Variables
    
    @IBOutlet weak var tbvPost: UITableView!
    var homeViewModel = HomeViewModel()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindData()
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "HomeCell", bundle: nil)
        tbvPost.register(nib, forCellReuseIdentifier: "HomeCell")
    }
    
    private func bindData() {
        unowned let strongSelf = self
        
        homeViewModel.post
            .asDriver()
            .drive(tbvPost.rx.items(cellIdentifier: "HomeCell", cellType: HomeCell.self)) { (_, post, cell) in
                cell.post = post
            }.disposed(by: disposeBag)
        
    }

}
