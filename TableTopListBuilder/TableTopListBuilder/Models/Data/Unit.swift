//
//  Unit.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 05/11/2020.
//

import Foundation

class Unit: Codable, IdentifiableProtocol, PointsProtocol {
    
    enum Role: String, Codable {
        
        case hq = "HQ"
        case troops = "Troops"
        case elites = "Elites"
        case fastAttack = "FastAttack"
        case heavySupport = "HeavySupport"
        case dedicatedTransport = "DedicatedTransport"
        case flyer = "Flyer"
        case fortification = "Fortification"
        case lordOfWar = "LordOfWar"
    }
    
    // MARK: Unit Variables
    
    public let role: Role
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
