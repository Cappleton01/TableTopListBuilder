//
//  CataloguesTableViewController.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 13/11/2020.
//

import UIKit

class CataloguesTableViewController: UITableViewController {

    typealias RowSelectionHandler = (_ catalogue: Catalogue) -> Void
    
    private static let reuseIdentifier = "reuseIdentifier"
    
    var catalogues: [Catalogue] = []
    var rowSelectionHandler: RowSelectionHandler?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Select Catalogue"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catalogues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = CataloguesTableViewController.reuseIdentifier
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        cell.textLabel?.text = catalogues[indexPath.row].name
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        rowSelectionHandler?(catalogues[indexPath.row])
    }
}
