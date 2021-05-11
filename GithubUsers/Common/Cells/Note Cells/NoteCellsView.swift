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
    @IBOutlet weak var noteImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        noteAvatarImageView.clipsToBounds = true
        noteAvatarImageView.layer.cornerRadius = 25
    }

    func configure(with model: User, cellType: CellType) {
        
        switch cellType {
        case .normal:
            self.noteNameLabel.text = model.login
            self.noteDetailsLabel.text = model.type
            self.noteAvatarImageView.loadImageViewFromURL(withUrl: URL(string: model.avatar_url)!)
            self.noteImageView.isHidden = true
        case.inverted:
            self.noteNameLabel.text = model.login
            self.noteDetailsLabel.text = model.type
            self.noteImageView.isHidden = true
            
            let image = UIImage()
            let avatarImage = image.loadImageFromURL(withUrl: URL(string: model.avatar_url)!)
            let rotatedImage = avatarImage.rotate(radians: .pi)
            self.noteAvatarImageView.image = rotatedImage
        case .note:
            self.noteNameLabel.text = model.login
            self.noteDetailsLabel.text = model.type
            self.noteAvatarImageView.loadImageViewFromURL(withUrl: URL(string: model.avatar_url)!)
        case .border:
            self.noteNameLabel.text = model.login
            self.noteNameLabel.font = UIFont.systemFont(ofSize: 13)
            
            self.noteDetailsLabel.text = model.type
            self.noteDetailsLabel.font = UIFont.boldSystemFont(ofSize: 17)
            self.noteDetailsLabel.textColor = UIColor.darkText
            
            self.noteImageView.isHidden = true
            
            let image = UIImage()
            let avatarImage = image.loadImageFromURL(withUrl: URL(string: model.avatar_url)!)
            let rotatedImage = avatarImage.rotate(radians: .pi)
            self.noteAvatarImageView.image = rotatedImage
        default:
            break
        }
    }
    
}
