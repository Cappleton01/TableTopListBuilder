//
//  Roster.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 05/11/2020.
//

import Foundation

class Roster: Codable, PointsProtocol, CommandPointsProtocol {
    
    // MARK: Roster Variables
    
    private let id: String
    var name: String
    let game: Game
    var forces: [RosterForce]
    var points: Int = -1
    var cp: Int = -1
    
    
    // MARK: Life Cycle
    
    init(name: String, game: Game, forces: [RosterForce]) {
        self.id = UUID().uuidString
        self.name = name
        self.game = game
        self.forces = forces
    }
}
