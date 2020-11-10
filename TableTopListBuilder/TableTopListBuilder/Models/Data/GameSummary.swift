//
//  GameSummary.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 09/11/2020.
//

import Foundation

struct GameSummary: Codable, Hashable {
    
    let id: Int
    let name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: GameSummary, rhs: GameSummary) -> Bool {
        return lhs.id == rhs.id
    }
}
