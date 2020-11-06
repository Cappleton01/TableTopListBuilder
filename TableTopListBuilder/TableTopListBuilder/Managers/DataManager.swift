//
//  DataManager.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 05/11/2020.
//

import Foundation

class DataManager {
    
    // MARK: DataManager Variables
    
    static let sharedInstance = DataManager()
    
    private(set) var data: [Data] = []
    
    
    // MARK: Life Cycle Methods
    
    private init() {
        
    }
    
    
    // MARK: Setup Methods
    
    func setup(completionHandler: @escaping () -> Void) {
        
        DispatchQueue.global().async {
            
            self.loadStoredData()
            completionHandler()
        }
    }
    
    
    // MARK: Stored Data Methods
    
    private func loadStoredData() {
        
        // TODO: check for data
        Thread.sleep(forTimeInterval: 3)
        
        self.data = []
    }
    
    private func storeData(_ roster: Roster) {
        
    }
    
    
    // MARK: Add/Removal Methods
    
    func addData(_ roster: Data) {
        
    }
    
    func removeData(_ roster: Data) {
        
    }
}
