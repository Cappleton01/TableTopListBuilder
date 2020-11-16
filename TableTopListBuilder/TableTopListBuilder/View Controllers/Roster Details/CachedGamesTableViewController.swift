//
//  CachedGamesTableViewController.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 13/11/2020.
//

import UIKit

class CachedGamesTableViewController: UITableViewController {
    
    typealias RowSelectionHandler = (_ game: Game) -> Void
    
    private static let reuseIdentifier = "reuseIdentifier"
    
    private let games = Array(GamesManager.sharedInstance.cachedGames)
    var rowSelectionHandler: RowSelectionHandler?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Select Game"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = CachedGamesTableViewController.reuseIdentifier
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        cell.textLabel?.text = games[indexPath.row].name
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        rowSelectionHandler?(games[indexPath.row])
    }
}
