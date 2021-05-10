//
//  InvertedcellsView.swift
//  GithubUsers
//
//  Created by Kevin Siundu on 10/05/2021.
//  Copyright © 2021 Kevin Siundu. All rights reserved.
//

import UIKit

class InvertedcellsView: UITableViewCell {
    
    @IBOutlet weak var invertedImageView: UIImageView!
    @IBOutlet weak var invertedNameLabel: UILabel!
    @IBOutlet weak var invertedDetailsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        invertedImageView.clipsToBounds = true
        invertedImageView.layer.cornerRadius = 25
    }

    func configure(with model: User) {
        self.invertedNameLabel.text = model.login
        self.invertedDetailsLabel.text = model.type
        
        let image = UIImage()
        let avatarImage = image.loadImageFromURL(withUrl: URL(string: model.avatar_url)!)
        let rotatedImage = avatarImage.rotate(radians: .pi)
        self.invertedImageView.image = rotatedImage
    }
    
}
