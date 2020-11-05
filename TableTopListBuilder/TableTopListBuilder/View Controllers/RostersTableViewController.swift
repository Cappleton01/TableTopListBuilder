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

    
    // MARK: UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rosters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}
