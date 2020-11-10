//
//  BaseRepository.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 09/11/2020.
//

import Foundation

class BaseRepository<Summary: Codable, Full: Codable> {
    
    func download(_ summary: Summary, completion: @escaping (Result<Full, Error>) -> Void) {
        
    }
    
    func fetch(completion: @escaping (Result<[Summary], Error>) -> Void) {
        
    }
    
    func stored(completion: @escaping (Result<[Full], Error>) -> Void) {
        
    }
    
    func store(_ obj: Full) throws {
        
    }
    
    func store(_ objs: [Full]) -> [Error]? {
        
        var errors: [Error]?
        
        for obj in objs {
            
            do {
                
                try store(obj)
            }
            catch {
                
                if errors == nil {
                    errors = []
                }
                
                errors?.append(error)
            }
        }
        
        return errors
    }
}
