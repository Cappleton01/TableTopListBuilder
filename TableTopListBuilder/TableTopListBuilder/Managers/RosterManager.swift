//
//  RosterManager.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 05/11/2020.
//

import Foundation

class RosterManager {
    
    // MARK: DataManager Variables
    
    static let sharedInstance = RosterManager()
    
    private(set) var rosters: [Roster] = []
    
    
    // MARK: Life Cycle Methods
    
    private init() {
        
    }
    
    
    // MARK: Setup Methods
    
    func setup(completionHandler: @escaping () -> Void) {
        
        DispatchQueue.global().async {
            
            self.loadStoredRosters()
            completionHandler()
        }
    }
    
    
    // MARK: Stored Roster Methods
    
    private func loadStoredRosters() {
        
        // TODO: check for data
        Thread.sleep(forTimeInterval: 3)
        
        self.rosters = []
    }
    
    private func storeRoster(_ roster: Roster) {
        
    }
    
    
    // MARK: Add/Removal Methods
    
    func addRoster(_ roster: Roster) {
        
    }
    
    func removeRoster(_ roster: Roster) {
        
    }
}
