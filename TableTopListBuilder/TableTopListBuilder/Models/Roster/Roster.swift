//
//  Roster.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 05/11/2020.
//

import Foundation

class Roster: Codable {
    
    // MARK: Roster Variables
    
    let game: Game
    var forces: [RosterForce]
}
