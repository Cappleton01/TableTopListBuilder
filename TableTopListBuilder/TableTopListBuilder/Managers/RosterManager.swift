//
//  RosterManager.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 05/11/2020.
//

import Foundation

class RosterManager {
    
    // MARK: Roster Variables
    
    static let sharedInstance = RosterManager()
    
    private(set) var rosters: [Roster] = []
    
    
    // MARK: Life Cycle Methods
    
    private init() {
        
    }
    
    
    // MARK: Setup Methods
    
    func setup(completion: @escaping () -> Void) {
        
        DispatchQueue.global().async {
            
            self.loadStoredRosters()
            completion()
        }
    }
    
    
    // MARK: Stored Roster Methods
    
    private func loadStoredRosters() {
        
        // TODO: check for data
        Thread.sleep(forTimeInterval: 1)
        
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
