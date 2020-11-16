//
//  RosterDetailsViewController.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 16/11/2020.
//

import UIKit

class RosterDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Variables
    
    private static let reuseIdentifier = "reuseIdentifier"
    
    var roster: Roster?
    
    @IBOutlet private var forcesTableView: UITableView!
    @IBOutlet private var detailsTabView: UIView!
    
    
    // MARK: View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let segmentedControl = UISegmentedControl(items: ["Forces", "Details"])
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueDidChange(_:)), for: .valueChanged)
        
        self.navigationItem.titleView = segmentedControl
        
        if roster == nil {
            
            let nc = RosterForceNavigationController(game: roster?.game)
            nc.handler = { (game, force) in
                
                self.addForce(force, game: game)
                self.dismiss(animated: true, completion: nil)
            }
            nc.modalPresentationStyle = .fullScreen
            
            self.present(nc, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: Helper Methods
    
    func addForce(_ force: RosterForce, game: Game) {
        
        let roster = self.roster ?? Roster(name: "New Roster", game: game, forces: [])
        roster.forces.append(force)
        
        if self.roster == nil {
            self.roster = roster
        }
        
        self.forcesTableView.reloadData()
    }
    
    
    // MARK: UI Callback Methods
    
    @IBAction @objc private func segmentedControlValueDidChange(_ sender: UISegmentedControl) {
        
        forcesTableView.isHidden = sender.selectedSegmentIndex != 0
        detailsTabView.isHidden = sender.selectedSegmentIndex != 1
    }
    
    
    // MARK: UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return roster?.forces.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let roster = self.roster else {
            NSLog("Should not be asking for a cell if there is no roster", "")
            return UITableViewCell()
        }
        
        let reuseIdentifier = RosterDetailsViewController.reuseIdentifier
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        cell.textLabel?.text = roster.forces[indexPath.row].catalogue.name
        
        return cell
    }
}
