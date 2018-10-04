//
//  HomeCell.swift
//  RxSwift_Instagram
//
//  Created by HOANGHUNG on 8/15/18.
//  Copyright © 2018 SVS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class HomeCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblNumberLikes: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    let disposeBag = DisposeBag()
    var viewModel = HomeCellViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        bindData()
//        btnLike.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.height / 2
        imgAvatar.clipsToBounds = true
    }
    
//    @objc func handleLike() {
//        unowned let strongSelf = self
//        print(viewModel.post.value)
//        viewModel.handleLike(FirebaseRef.refPost.child(viewModel.post.value?.id ?? ""))
//            .subscribe(onNext: { (p) in
//                strongSelf.viewModel.post.value = p
//            }, onError: { (error) in
//                print(error.localizedDescription)
//            }).disposed(by: disposeBag)
//    }
    
    private func bindData() {
        unowned let strongSelf = self
        
//        viewModel.post.asDriver()
//            .drive(onNext: { (p) in
//                guard let p = p else { return }
//                strongSelf.setupUI(p)
//            }).disposed(by: disposeBag)
        
        btnLike.rx.tap.asObservable().debounce(0.2, scheduler: MainScheduler.instance)
            .flatMapLatest({ _ in
                strongSelf.viewModel.handleLike(FirebaseRef.refPost.child((strongSelf.viewModel.post.value?.id)!))
            })
            .subscribe(onNext: { (p) in
//                strongSelf.viewModel.post.value = p
                print(p)
            }, onError: { (error) in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    func setupUI(_ p: Post) {
        viewModel.post.value = p
        lblName.text = p.userName
        if let urlStatus = URL(string: p.urlStatus) {
            imgStatus.kf.setImage(with: urlStatus)
        }
        if let urlAvatar = URL(string: p.avatarUrl) {
            imgAvatar.kf.setImage(with: urlAvatar)
        }
        lblStatus.text = p.status
        
        let imageName = !p.isLiked ? "like" : "likeSelected"
        btnLike.setImage(UIImage(named:imageName), for: .normal)
        
        // display a message for Likes
        guard let count = p.likeCount else {
            return
        }
        
        if count != 0 {
            var countString = ""
            if count == 1 {
                countString = "\(count) Like"
            } else {
                countString = "\(count) Likes"
            }
            lblNumberLikes.text = countString
        } else if p.likeCount == 0 {
            lblNumberLikes.text = "Be the first to Like this"
        }
    }
    
}
