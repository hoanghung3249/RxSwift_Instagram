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
    
    var post: Post! {
        didSet {
            guard let p = post else { return }
            
            lblName.text = p.userName
            if let urlStatus = URL(string: p.urlStatus) {
                imgStatus.kf.setImage(with: urlStatus)
            }
            if let urlAvatar = URL(string: p.avatarUrl) {
                imgAvatar.kf.setImage(with: urlAvatar)
            }
            lblStatus.text = p.status
            lblNumberLikes.text = p.likeCount == nil || p.likeCount == 0 ? "Be the first to Like this" : "\(p.likeCount!)"
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        imgAvatar.layer.cornerRadius = imgAvatar.frame.size.height / 2
        imgAvatar.clipsToBounds = true
    }
    
}
