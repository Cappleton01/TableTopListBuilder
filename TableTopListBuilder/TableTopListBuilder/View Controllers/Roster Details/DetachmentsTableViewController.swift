//
//  DetachmentsTableViewController.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 13/11/2020.
//

import UIKit

class DetachmentsTableViewController: UITableViewController {

    typealias RowSelectionHandler = (_ detachment: Detachment) -> Void
    
    private static let reuseIdentifier = "reuseIdentifier"
    
    var detachments: [Detachment] = []
    var rowSelectionHandler: RowSelectionHandler?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Select Detachment"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detachments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = DetachmentsTableViewController.reuseIdentifier
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        cell.textLabel?.text = detachments[indexPath.row].name
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        rowSelectionHandler?(detachments[indexPath.row])
    }
}
