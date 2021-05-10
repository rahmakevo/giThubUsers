//
//  NoteCellsView.swift
//  GithubUsers
//
//  Created by Kevin Siundu on 10/05/2021.
//  Copyright © 2021 Kevin Siundu. All rights reserved.
//

import UIKit

class NoteCellsView: UITableViewCell {
    
    @IBOutlet weak var noteAvatarImageView: UIImageView!
    @IBOutlet weak var noteNameLabel: UILabel!
    @IBOutlet weak var noteDetailsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        noteAvatarImageView.clipsToBounds = true
        noteAvatarImageView.layer.cornerRadius = 25
    }

    func configure(with model: User) {
        self.noteNameLabel.text = model.login
        self.noteDetailsLabel.text = model.type
        self.noteAvatarImageView.loadImageViewFromURL(withUrl: URL(string: model.avatar_url)!)
    }
    
}
