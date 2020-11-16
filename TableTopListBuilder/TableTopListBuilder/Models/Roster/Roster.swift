//
//  Roster.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 05/11/2020.
//

import Foundation

class Roster: Codable {
    
    // MARK: Roster Variables
    
    private let id: String
    var name: String
    let game: Game
    var forces: [RosterForce]
    
    
    // MARK: Life Cycle
    
    init(name: String, game: Game, forces: [RosterForce]) {
        self.id = UUID().uuidString
        self.name = name
        self.game = game
        self.forces = forces
    }
}
