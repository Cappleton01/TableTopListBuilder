//
//  GameRelease.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 06/11/2020.
//

import Foundation

struct GameRelease: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case tagName = "tag_name"
        case name
        case body
        case zipURL = "zipball_url"
    }
    
    let id: Int
    let tagName: String
    let name: String
    let body: String
    let zipURL: String
}
