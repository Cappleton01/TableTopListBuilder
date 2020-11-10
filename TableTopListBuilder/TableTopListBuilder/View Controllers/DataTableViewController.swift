//
//  DataTableViewController.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 05/11/2020.
//

import UIKit

class DataTableViewController: UITableViewController {
    
    // MARK: DataTableViewController Variables
    
    private static let reuseIdentifier = "reuseIdentifier"
    
    private var games: [GameSummary] = []
    
    
    // MARK: View Loading
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.games = Array(GamesManager.sharedInstance.activeGames)
        
        if self.games.isEmpty {
            
            let nc = UINavigationController(rootViewController: GamesTableViewController())
            nc.modalPresentationStyle = .fullScreen
            
            self.tabBarController?.present(nc, animated: true, completion: nil)
        }
        
        self.tableView.reloadData()
    }

    
    // MARK: UITableViewDataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = DataTableViewController.reuseIdentifier
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        cell.textLabel?.text = games[indexPath.row].name
        
        return cell
    }
    
    
    // MARK: UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
