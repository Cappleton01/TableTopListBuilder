//
//  RepositoriesTableViewController.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 06/11/2020.
//

import UIKit

class RepositoriesTableViewController: UITableViewController {
    
    private static let reuseIdentifier = "reuseIdentifier"
    
    var repos: [Repository] = []
    private var selectedRepos: Set<Repository> = []

    // MARK: View Loading Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Repositories"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done(_:)))
        
        RepositoryManager.sharedInstance.requestData { (result) in
            
            DispatchQueue.main.async {
                
                switch result {
                case .success(let repos):
                    self.handleRepositoryRequestSuccess(repos: repos)
                case .failure(let error):
                    self.handleRepositoryRequestFailure(error: error)
                }
            }
        }
    }
    
    
    // MARK: Data Retrieval Handler Methods
    
    private func handleRepositoryRequestSuccess(repos: [Repository]) {
        
        self.repos = repos
        self.tableView.reloadData()
    }
    
    private func handleRepositoryRequestFailure(error: RepositoryManager.Error) {
        
        // TODO: show alert with correct text
        switch error {
        case .invalidURL:
            ()
        case .httpRequestFailed(_):
            ()
        case .decodeFailure:
            ()
        }
    }
    
    
    // MARK: Helper Methods
    
    private func repoStatusText(for downloadStatus: RepositoryManager.RepositoryStatus) -> String? {
        
        switch downloadStatus {
        case .notDownloaded: return "Not Downloaded"
        case .downloading: return "Downloading"
        case .downloaded: return nil
        case .failed: return "Download Failed"
        case .outOfDate: return "Update Available"
        }
    }
    
    private func shouldHighlightRow(at indexPath: IndexPath) -> Bool {
        return !RepositoryManager.sharedInstance.activeRepositories.contains(repos[indexPath.row])
    }
    
    private func toggleRowSelection(at indexPath: IndexPath) {
        
        let repo = repos[indexPath.row]
        
        if selectedRepos.contains(repo) {
            
            selectedRepos.remove(repo)
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
        else {
            selectedRepos.insert(repo)
        }
    }
    
    
    // MARK: UI Callback methods
    
    @objc private func done(_ sender: UIBarButtonItem) {
        
        // TODO: loading indicator etc
        RepositoryManager.sharedInstance.addActiveRepositories(Array(selectedRepos))
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = RepositoriesTableViewController.reuseIdentifier
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        cell.textLabel?.text = repos[indexPath.row].name
        cell.detailTextLabel?.text = repoStatusText(for: RepositoryManager.sharedInstance.status(for: repos[indexPath.row]))
        
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
