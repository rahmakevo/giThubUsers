//
//  ViewController.swift
//  GithubUsers
//
//  Created by Kevin Siundu on 07/05/2021.
//  Copyright © 2021 Kevin Siundu. All rights reserved.
//

import UIKit
import Combine
import CoreData
import Reachability
import SkeletonView

class ViewController: UIViewController {
    // MARK: Variables declearations
    var resultSearchController = UISearchController()
    @IBOutlet weak var tableView: UITableView!
    private var state = State(users: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        definesPresentationContext = true
        self.showSpinner(onView: self.view)
        
        // start a notifier to check for connection
        do {
            try self.state.reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        // if connection is present proceed to showing list
        self.state.reachability.whenReachable = { _ in
            self.fetchUsers()
            self.setupViews()
            
            self.state.reachability.stopNotifier()
        }
        
        // if connection is unstable setup skeleton view only
        self.state.reachability.whenUnreachable = { _ in
            self.setupViews()
            
            // fetch Users from CoreData
            self.fetchData()
        }
        
    }
    
    // Setup Views in UIView
    // methods instantiation for views on Did Load
    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "NoteCellsView", bundle: nil), forCellReuseIdentifier: "NoteCellsView")
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.isSkeletonable = true
        tableView.showSkeleton(usingColor: .concrete, transition: .crossDissolve(0.25))
    }
    
    // fetch Users From API Function
    func fetchUsers() {
        self.state.users.removeAll()
        let networkClient = NetworkClient()
        let userRepo = UserRepository(networkClient: networkClient)
        userRepo.searchUsers(completion: {
            success in
            do {
                self.state.users = try success.get()
                DispatchQueue.main.async {
                    self.tableView.stopSkeletonAnimation()
                    self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                    self.tableView.reloadData()
                    
                    self.saveData(self.state.users)

                }
                self.removeSpinner()
            } catch {
                print("error fetching users")
            }
        })
    }
    
    // move To Next Controller Function
    func pushView(user: User) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsVC.user = user
        [self .present(detailsVC, animated: true, completion: nil)]
    }
    
    // Filter Function
    func filterRowsForSearchText(_ searchText: String) {
        self.state.filteredTabledata = self.state.users.filter({ (user: User) -> Bool in
            return user.login.lowercased().contains(searchText.lowercased()) ||
            user.login.lowercased().contains(searchText.lowercased())
        })
        self.tableView.reloadData()
    }
    
    // Core Data Save Data Function to UsersEntity
    func saveData(_ user: [User]) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        for user in user {
            let idString = String("\(user.id)")
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "UsersEntity", into: context)
            
            newUser.setValue(user.login, forKey: "login")
            newUser.setValue(idString, forKey: "id")
            newUser.setValue(user.node_id, forKey: "node_id")
            newUser.setValue(user.avatar_url, forKey: "avatar_url")
            newUser.setValue(user.gravatar_id, forKey: "gravatar_id")
            newUser.setValue(user.events_url, forKey: "events_url")
            newUser.setValue(user.followers_url, forKey: "followers_url")
            newUser.setValue(user.following_url, forKey: "following_url")
            newUser.setValue(user.gists_url, forKey: "gists_url")
            newUser.setValue(user.url, forKey: "url")
            newUser.setValue(user.html_url, forKey: "html_url")
            newUser.setValue(user.organizations_url, forKey: "organizations_url")
            newUser.setValue(user.received_events_url, forKey: "received_events_url")
            newUser.setValue(user.repos_url, forKey: "repos_url")
            newUser.setValue(user.site_admin, forKey: "site_admin")
            newUser.setValue(user.starred_url, forKey: "starred_url")
            newUser.setValue(user.subscriptions_url, forKey: "subscriptions_url")
            newUser.setValue(user.type, forKey: "type")
            newUser.setValue("Some note texts", forKey: "note")
        }
        
        do {
            try context.save()
        } catch {
            print("error saving data to Core Data")
        }
    }
    
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
                    
                    let user = User(login: login, id: idInt, node_id: node_id, avatar_url: avatar_url, gravatar_id: gravatar_id, url: url, html_url: html_url, followers_url: followers_url, following_url: following_url, gists_url: gists_url, starred_url: starred_url, subscriptions_url: subscriptions_url, organizations_url: organizations_url, repos_url: repos_url, events_url: events_url, received_events_url: received_events_url, type: type, site_admin: site_admin, name: "", bio: "", company: "", blog: "", followers: 0, following: 0)
                    self.state.coreDataUsers.append(user)
                }
                
                // print saved user entity
            } catch {
                print("error fetching data")
            }
        }
}

// Mark: SkeletonViewDataSource, TableViewDelegate & SearchResultsDelegate

extension ViewController: SkeletonTableViewDataSource,UITableViewDelegate, UISearchResultsUpdating {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (resultSearchController.isActive && resultSearchController.searchBar.text != "") {
            return self.state.filteredTabledata.count
        } else {
            return self.state.users.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var displayModel = [User]()
        
        if (resultSearchController.isActive && resultSearchController.searchBar.text != "") {
            displayModel = self.state.filteredTabledata
        } else {
            // check if users has been loaded
            if (self.state.users != nil && !self.state.reachability.isReachable) {
                // load users from core Data
                displayModel = self.state.coreDataUsers
            } else {
                displayModel = self.state.users
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCellsView", for: indexPath) as! NoteCellsView
        
        // loop through array for every first element make the cellType.normal
        // for every second element in array make cellType.note
        // for every third element in arrray make cellType.inverted
        // for every fourth element invert the image & colors and follow the pattern until array is exhausted
        switch indexPath.row % 4 {
        case 0:
            self.state.cellType = CellType.normal
        case 1:
            self.state.cellType = CellType.note
        case 2:
            self.state.cellType = CellType.inverted
        case 3:
            self.state.cellType = CellType.border
        default:
            break
        }
        
        cell.configure(with: displayModel[indexPath.row], cellType: self.state.cellType)
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "NoteCellsView"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resultSearchController.isActive = false
        tableView.deselectRow(at: indexPath, animated: false)
        pushView(user: self.state.users[indexPath.row])
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let term = searchController.searchBar.text {
            filterRowsForSearchText(term)
        }        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsViewController" {
            let viewController = segue.destination as! UINavigationController
            _ = viewController.topViewController as! DetailsViewController
        }
    }
    
}

// private context to hold data. Ensures we are able to save data and reuse anywhere where required
struct State {
    var users = [User]()
    var filteredTabledata = [User]()
    let reachability = try! Reachability()
    var cellType: CellType = CellType.normal
    var coreDataUsers = [User]()
}


