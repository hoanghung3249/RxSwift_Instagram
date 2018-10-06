//
//  HomeViewController.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 8/4/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import UIKit
import RxSwift

class HomeViewController: BaseViewController {
    
    // MARK: - Outlets and Variables
    
    @IBOutlet weak var tbvPost: UITableView!
    var homeViewModel = HomeViewModel()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupTableView()
        bindData()
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "HomeCell", bundle: nil)
        tbvPost.register(nib, forCellReuseIdentifier: "HomeCell")
        tbvPost.separatorStyle = .none
    }
    
    private func setupNav() {
        self.navigationController?.navigationBar.titleTextAttributes = [.font: Font.Billabong(30)]
        self.navigationItem.title = "Instagram"
    }
    
    private func bindData() {
        unowned let strongSelf = self

        homeViewModel.postUpdated.asObservable()
            .subscribe(onNext: { (post) in
                if let post = post {
                    strongSelf.homeViewModel.updateLike(with: post.id)
                }
            }).disposed(by: disposeBag)
        
        homeViewModel.posts
            .asDriver()
            .drive(tbvPost.rx.items(cellIdentifier: "HomeCell", cellType: HomeCell.self)) { (_, post, cell) in
                cell.p = post
                cell.delegate = strongSelf
            }.disposed(by: disposeBag)
    }

}

// MARK: - HomeCell Delegate
extension HomeViewController: HomeCellDelegate {
    func updatePost(_ p: Post) {
        homeViewModel.postUpdated.value = p
    }
}
