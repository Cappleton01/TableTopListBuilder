//
//  DataTableViewController.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 05/11/2020.
//

import UIKit

class DataTableViewController: UITableViewController {
    
    // MARK: DataTableViewController Variables
    
    var data: [Data] = []
    
    
    // MARK: View Loading
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if DataManager.sharedInstance.data.isEmpty {
            
            // TODO: show new data form?
        }
    }

    
    // MARK: UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}
