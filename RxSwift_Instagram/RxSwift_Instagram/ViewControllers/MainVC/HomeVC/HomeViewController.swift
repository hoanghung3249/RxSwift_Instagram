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
        tbvPost.dataSource = self
        tbvPost.delegate = self
    }
    
    private func setupNav() {
        self.navigationController?.navigationBar.titleTextAttributes = [.font: Font.Billabong(30)]
        self.navigationItem.title = "Instagram"
    }
    
    private func bindData() {
        unowned let strongSelf = self
        
        homeViewModel.delegate = self
//        homeViewModel.handleDataChanged()
        homeViewModel.postUpdated.asObservable()
            .subscribe(onNext: { (post) in
                if let post = post {
                    strongSelf.homeViewModel.updateLike(with: post.id)
                }
            }).disposed(by: disposeBag)
        
//        homeViewModel.posts
//            .asDriver()
//            .drive(tbvPost.rx.items(cellIdentifier: "HomeCell", cellType: HomeCell.self)) { (_, post, cell) in
//                print(post)
//                cell.viewModel.post.value = post
//            }.disposed(by: disposeBag)
        
        homeViewModel.posts.asObservable()
            .debounce(0.1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { (posts) in
                strongSelf.tbvPost.reloadData()
            }).disposed(by: disposeBag)
        
    }

}

// MARK: - HomeView Model Delegate
extension HomeViewController: HomeViewModelDelegate {
    
    func didUpdatePost(_ post: Post) {
        homeViewModel.postUpdated.value = post
    }
    
}

// MARK: - TableView Datasource & Delegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.posts.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: HomeCell.self, at: indexPath)
        let post = homeViewModel.posts.value[indexPath.row]
//        cell.viewModel.post.value = post
        cell.setupUI(post)
        return cell
    }
    
}
