//
//  Game.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 05/11/2020.
//

import Foundation

struct Game: Codable, Hashable {
    
    // MARK: Game Variables
    
    let id: Int
    let name: String
    let detachments: [Detachment]
    let catalogues: [Catalogue]
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.id == rhs.id
    }
}
