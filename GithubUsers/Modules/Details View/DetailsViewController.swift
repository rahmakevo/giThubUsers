//
//  DetailsViewController.swift
//  GithubUsers
//
//  Created by Kevin Siundu on 10/05/2021.
//  Copyright © 2021 Kevin Siundu. All rights reserved.
//

import UIKit
import CoreData
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
    @IBOutlet weak var notesField: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private var state = State()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
    }
    
    @IBAction func saveNotesData(_ sender: Any) {
        self.showSpinner(onView: self.view)
        updateNotes(notesField.text ?? "")
        notesField.text = " "
    }
    
    @IBAction func backImageTapped(_ sender: Any) {
        [self .dismiss(animated: true, completion: nil)]
    }
    
    func setupViews() {
        // show spinner before making network call
        self.showSpinner(onView: self.view)
        // creating an instance of network client
        let networkClient = NetworkClient()
        // creating an instance of user repository
        let userRepo = UserRepository(networkClient: networkClient)
        // making the network call using Combine to publish the Result and Error incase of failure
        userRepo.getUsersAccount(name: user?.login ?? "tawk").sink(receiveCompletion: { (completion) in
            switch completion {
            case .finished: break
            case .failure(_): break
            }
            }) { user in
                
                // load user views
                self.landingImageView.loadImageViewFromURL(withUrl: URL(string: user.avatar_url)!)
                self.titleLabel.text = user.name
                self.state.user = user
                self.nameLabel.text = "name : \(user.name ?? "")"
                self.blogLabel.text = "blog : \(user.blog ?? "")"
                self.companyLabel.text = "company : \(user.company ?? "")"
                self.followingText.text = "\(user.following ?? 0)"
                self.followersText.text = "\(user.followers ?? 0)"
                self.notesField.placeholder = user.bio
                
                // remove spinner when data is loaded
                self.removeSpinner()
        }.store(in: &subscriptions)
        
    }
    
    // Fetch Data from CoreData
    func fetchData() {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UsersEntity")
    1
            do {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    let login = data.value(forKey: "login") as! String
                    
                    let id = data.value(forKey: "id") as! String
                    let idInt = Int(id) ?? 0
                    
                    let node_id = data.value(forKey: "node_id") as! String
                    let avatar_url = data.value(forKey: "avatar_url") as! String
                    let gravatar_id = data.value(forKey: "gravatar_id") as! String
                    let url = data.value(forKey: "url") as! String
                    let html_url = data.value(forKey: "html_url") as! String
                    let followers_url = data.value(forKey: "followers_url") as! String
                    let following_url = data.value(forKey: "following_url") as! String
                    let gists_url = data.value(forKey: "gists_url") as! String
                    
                    let starred_url = data.value(forKey: "starred_url") as! String
                    let subscriptions_url = data.value(forKey: "subscriptions_url") as! String
                    let organizations_url = data.value(forKey: "organizations_url") as! String
                    let repos_url = data.value(forKey: "repos_url") as! String
                    
                    let events_url = data.value(forKey: "events_url") as! String
                    let received_events_url = data.value(forKey: "received_events_url") as! String
                    let type = data.value(forKey: "type") as! String
                    let site_admin = data.value(forKey: "site_admin") as! Bool
                    self.state.noteData = data.value(forKey: "note") as! String
                    
                    let user = User(login: login, id: idInt, node_id: node_id, avatar_url: avatar_url, gravatar_id: gravatar_id, url: url, html_url: html_url, followers_url: followers_url, following_url: following_url, gists_url: gists_url, starred_url: starred_url, subscriptions_url: subscriptions_url, organizations_url: organizations_url, repos_url: repos_url, events_url: events_url, received_events_url: received_events_url, type: type, site_admin: site_admin, name: "", bio: "", company: "", blog: "", followers: 0, following: 0)
                    self.state.coreDataUsers.append(user)
                    notesField.text = self.state.noteData
                    
                    self.removeSpinner()
                }
                
                // print saved user entity
            } catch {
                self.removeSpinner()
                print("error fetching data")
            }
        }
    
    func updateNotes(_ notes: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UsersEntity")
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                data.setValue(notes, forKey: "note")
            }
            fetchData()
            print("data saved successfully")
        } catch {
            self.removeSpinner()
            print("error fetching data")
        }
    }
    
    struct State {
        // saving User to state to save the data on the page
        var user: User?
        var coreDataUsers = [User]()
        var noteData: String?
    }
}
