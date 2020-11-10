//
//  RostersTableViewController.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 05/11/2020.
//

import UIKit

class RostersTableViewController: UITableViewController {
    
    // MARK: RostersTableViewController Variables
    
    var rosters: [Roster] = []
    
    
    // MARK: View Loading Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform initial setup
        let setupVC = SetupViewController(nibName: "SetupViewController", bundle: nil)
        setupVC.modalPresentationStyle = .fullScreen
        
        self.tabBarController?.present(setupVC, animated: false) {
            
            self.setup()
        }
    }
    
    
    // MARK: Helper Methods
    
    private func setup() {
        
        GamesManager.sharedInstance.setup {
            RosterManager.sharedInstance.setup {
                DispatchQueue.main.async {
                    
                    self.setupCompletion()
                }
            }
        }
    }
    
    private func setupCompletion() {
        
        self.tabBarController?.dismiss(animated: true) {
            
            if GamesManager.sharedInstance.activeGames.isEmpty {
                
                self.tabBarController?.selectedIndex = 1
            }
            else if RosterManager.sharedInstance.rosters.isEmpty {
                
                // TODO: Present new roster form?
            }
        }
    }

    
    // MARK: UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rosters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}
