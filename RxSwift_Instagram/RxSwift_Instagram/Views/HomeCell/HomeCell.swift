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
            lblStatus.text = p.status
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
