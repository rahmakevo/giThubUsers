//
//  ViewController.swift
//  GithubUsers
//
//  Created by Kevin Siundu on 07/05/2021.
//  Copyright © 2021 Kevin Siundu. All rights reserved.
//

import UIKit
import Combine
import SkeletonView

class ViewController: UIViewController {
    var resultSearchController = UISearchController()
    @IBOutlet weak var tableView: UITableView!
    private var state = State(users: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        definesPresentationContext = true
        setupViews()
        fetchUsers()
    }
    
    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "InvertedcellsView", bundle: nil), forCellReuseIdentifier: "InvertedcellsView")
        tableView.register(UINib(nibName: "NoteCellsView", bundle: nil), forCellReuseIdentifier: "NoteCellsView")
        tableView.register(UINib(nibName: "NormalCellView", bundle: nil), forCellReuseIdentifier: "NormalCellView")
        
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
    
    func fetchUsers() {
        self.showSpinner(onView: self.view)
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
                }
                
                self.removeSpinner()
            } catch {
                print("error fetching users")
                self.removeSpinner()
            }
        })
    }
    
    func pushView(user: User) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsVC.user = user
        [self .present(detailsVC, animated: true, completion: nil)]
    }
    
    func filterRowsForSearchText(_ searchText: String) {
        self.state.filteredTabledata = self.state.users.filter({ (user: User) -> Bool in
            return user.login.lowercased().contains(searchText.lowercased()) ||
            user.login.lowercased().contains(searchText.lowercased())
        })
        
        self.tableView.reloadData()
    }
}

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
            displayModel = self.state.users
        }
        
        switch displayModel[indexPath.row].id {
        case 0...15:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NormalCellView", for: indexPath) as! NormalCellView
            cell.configure(with: displayModel[indexPath.row])
            return cell
        case 16...30:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCellsView", for: indexPath) as! NoteCellsView
            cell.configure(with: displayModel[indexPath.row])
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvertedcellsView", for: indexPath) as! InvertedcellsView
            cell.configure(with: displayModel[indexPath.row])
            return cell
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "NormalCellView"
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
            let controller = viewController.topViewController as! DetailsViewController
        }
    }
    
}

struct State {
    var users = [User]()
    var filteredTabledata = [User]()
}


