//
//  GamesTableViewController.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 06/11/2020.
//

import UIKit

class GamesTableViewController: UITableViewController {
    
    private static let reuseIdentifier = "reuseIdentifier"
    
    var games: [GameSummary] = []
    private var selectedGames: Set<GameSummary> = []

    // MARK: View Loading Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Repositories"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done(_:)))
        
        GamesManager.sharedInstance.requestData { (result) in
            
            DispatchQueue.main.async {
                
                switch result {
                case .success(let games):
                    self.handleRepositoryRequestSuccess(games: games)
                case .failure(let error):
                    self.handleRepositoryRequestFailure(error: error)
                }
            }
        }
    }
    
    
    // MARK: Data Retrieval Handler Methods
    
    private func handleRepositoryRequestSuccess(games: [GameSummary]) {
        
        self.games = games
        self.tableView.reloadData()
    }
    
    private func handleRepositoryRequestFailure(error: Error) {
        
        // TODO: show alert with correct text
    }
    
    
    // MARK: Helper Methods
    
    private func gameStatusText(for downloadStatus: GamesManager.RepositoryStatus) -> String? {
        
        switch downloadStatus {
        case .notDownloaded: return "Not Downloaded"
        case .downloading: return "Downloading"
        case .downloaded: return nil
        case .failed: return "Download Failed"
        case .outOfDate: return "Update Available"
        }
    }
    
    private func shouldHighlightRow(at indexPath: IndexPath) -> Bool {
        return !GamesManager.sharedInstance.activeGames.contains(games[indexPath.row])
    }
    
    private func toggleRowSelection(at indexPath: IndexPath) {
        
        let repo = games[indexPath.row]
        
        if selectedGames.contains(repo) {
            
            selectedGames.remove(repo)
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
        else {
            selectedGames.insert(repo)
        }
    }
    
    
    // MARK: UI Callback methods
    
    @objc private func done(_ sender: UIBarButtonItem) {
        
        // TODO: loading indicator etc
        GamesManager.sharedInstance.addActiveGames(Array(selectedGames))
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = GamesTableViewController.reuseIdentifier
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        cell.textLabel?.text = games[indexPath.row].name
        cell.detailTextLabel?.text = gameStatusText(for: GamesManager.sharedInstance.status(for: games[indexPath.row]))
        
        return cell
    }
    
    
    // MARK: UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        self.shouldHighlightRow(at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.toggleRowSelection(at: indexPath)
    }
}
