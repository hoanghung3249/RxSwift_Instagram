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

protocol HomeCellDelegate: class {
    func updatePost(_ p: Post)
}

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
    var idPost = ""
    weak var delegate: HomeCellDelegate?
    var p: Post! {
        didSet {
            idPost = p.id
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        bindData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.height / 2
        imgAvatar.clipsToBounds = true
    }
    
    private func bindData() {
        unowned let strongSelf = self
        
        btnLike.rx.tap.asObservable().debounce(0.2, scheduler: MainScheduler.instance)
            .flatMapLatest({ _ in
                strongSelf.viewModel.handleLike(FirebaseRef.refPost.child(strongSelf.idPost))
            })
            .subscribe(onNext: { (p) in
                strongSelf.delegate?.updatePost(p)
            }, onError: { (error) in
                print(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
}
