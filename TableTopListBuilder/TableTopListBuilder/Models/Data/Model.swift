//
//  Model.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 05/11/2020.
//

import UIKit

public class Model: Codable, IdentifiableProtocol, PointsProtocol {
    
    // MARK: Model Variables
    
    public let name: String
    public let stats: ModelStats
    public let min: Int
    public let max: Int?
    
    
    // MARK: IdentifiableProtocol Variables
    
    public let id: String
    
    
    // MARK: PointsProtocol Variables
    
    public let points: Int
}
