//
//  NormalCellView.swift
//  GithubUsers
//
//  Created by Kevin Siundu on 10/05/2021.
//  Copyright © 2021 Kevin Siundu. All rights reserved.
//

import UIKit

class NormalCellView: UITableViewCell {
    
    @IBOutlet weak var normalAvatarImage: UIImageView!
    @IBOutlet weak var normalNameLabel: UILabel!
    @IBOutlet weak var normalDetailsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        normalAvatarImage.clipsToBounds = true
        normalAvatarImage.layer.cornerRadius = 25
    }
    
    func configure(with model: User) {
        self.normalNameLabel.text = model.login
        self.normalNameLabel.isSkeletonable = true
        
        self.normalDetailsLabel.text = model.type
        self.normalNameLabel.isSkeletonable = true
        
        self.normalAvatarImage.loadImageViewFromURL(withUrl: URL(string: model.avatar_url)!)
    }
    
}
