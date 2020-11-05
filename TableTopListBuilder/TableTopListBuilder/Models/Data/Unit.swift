//
//  Unit.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 05/11/2020.
//

import Foundation

class Unit: Codable, IdentifiableProtocol, PointsProtocol {
    
    // MARK: Unit Variables
    
    public let name: String
    public let minUnitSize: Int
    public let maxUnitSize: Int
    public let models: [Model]
    public let description: String?
    
    
    // MARK: IdentifiableProtocol Variables
    
    public let id: String
    
    
    // MARK: PointsProtocol Variables
    
    public var points: Int {
        
        var points = 0
        
        for model in models {
            
            points += model.points
        }
        
        return points
    }
}
