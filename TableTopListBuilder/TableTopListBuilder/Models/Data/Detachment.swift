//
//  Detachment.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 13/11/2020.
//

import Foundation

struct Detachment: Codable, CommandPointsProtocol {
    
    public struct RoleSettings: Codable, Hashable {
        
        let role: Unit.Role
        let min: Int
        let max: Int
        
        public static func ==(lhs: RoleSettings, rhs: RoleSettings) -> Bool {
            return lhs.role == rhs.role
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(role)
        }
    }
    
    
    public let name: String
    //public let roleSettings: Set<RoleSettings>
    public let cp: Int
    // TODO: Restriction keywords
    public let commandPointsBenefit: Int?
    // TODO: Dedicated transports rule
    
    
    // MARK: - Role Settings Helper Methods
    
    public func roleSettings(for role: Unit.Role) -> RoleSettings? {
        return nil
        //return roleSettings.first() { $0.role == role }
    }
}
