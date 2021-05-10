//
//  DetailsViewController.swift
//  GithubUsers
//
//  Created by Kevin Siundu on 10/05/2021.
//  Copyright © 2021 Kevin Siundu. All rights reserved.
//

import UIKit
import Combine

class DetailsViewController: UIViewController {
    
    var subscriptions = Set<AnyCancellable>()
    var user: User?
    
    @IBOutlet weak var landingImageView: UIImageView!
    @IBOutlet weak var followersText: UILabel!
    @IBOutlet weak var followingText: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var blogLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private var state = State()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
    }
    
    @IBAction func backImageTapped(_ sender: Any) {
        [self .dismiss(animated: true, completion: nil)]
    }
    
    func setupViews() {
        self.showSpinner(onView: self.view)
        let networkClient = NetworkClient()
        let userRepo = UserRepository(networkClient: networkClient)
        userRepo.getUsersAccount(name: user?.login ?? "tawk").sink(receiveCompletion: { (completion) in
            switch completion {
            case .finished: break
            case .failure(_): break
            }
            }) { user in
                self.landingImageView.loadImageViewFromURL(withUrl: URL(string: user.avatar_url)!)
                self.titleLabel.text = user.login
                self.state.user = user
                self.nameLabel.text = "name : \(user.login)"
                self.blogLabel.text = "blog : \(user.blog ?? "")"
                self.companyLabel.text = "company : \(user.company ?? "")"
                self.followingText.text = "\(user.following ?? 0)"
                self.followersText.text = "\(user.followers ?? 0)"
                self.removeSpinner()
        }.store(in: &subscriptions)
        
    }
    
    struct State {
        var user: User?
    }
}
