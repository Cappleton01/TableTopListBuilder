//
//  GamesRepository.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 09/11/2020.
//

import Foundation

class GamesRepository: BaseRepository<GameSummary, Game> {
    
    enum Error: Swift.Error {
        case unknown
        case invalidURL
    }
    
    private static let gamesFolder = "Games"
    private static let gameSummaryExtension = "gs"
    private static let detachmentsExtension = "det"
    private static let catalogueExtension = "cat"
    
    private var gamesFolderURL: URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(GamesRepository.gamesFolder)
    }
    
    
    // MARK: BaseRepository Methods
    
    override func download(_ summary: GameSummary, completion: @escaping (Result<Game, Swift.Error>) -> Void) {
        
        guard let url = URL(string: "https://api.github.com/repos/TTLBData/\(summary.name)/releases/latest") else {
            completion(.failure(Error.invalidURL))
            return
        }
        
        DownloadManager.sharedInstance.download(url: url, type: GameRelease.self) { (result) in
            
            switch result {
            
            case .success(let release):
                
                guard let zipURL = URL(string: release.zipURL) else {
                    completion(.failure(Error.invalidURL))
                    return
                }
                
                let extractionURL = self.gamesURL(for: summary.name)
                
                DownloadManager.sharedInstance.downloadZip(url: zipURL, extractionURL: extractionURL) { (result) in
                    
                    switch result {
                    
                    case .success(_):
                        
                        do {
                            let summaryData = try JSONEncoder().encode(summary)
                            
                            try summaryData.write(to: self.gameSummaryURL(for: summary.name))
                            
                            completion(.success(Game(id: summary.id,
                                                     name: summary.name,
                                                     detachments: try self.loadDetachments(from: extractionURL),
                                                     catalogues: try self.loadCatalogues(from: extractionURL))))
                        }
                        catch {
                            
                            // TODO: custom error
                            completion(.failure(error))
                        }
                        
                    case .failure(let error):
                        
                        // TODO: custom error
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                
                // TODO: custom error
                completion(.failure(error))
            }
        }
    }
    
    override func fetch(completion: @escaping (Result<[GameSummary], Swift.Error>) -> Void) {
        
        guard let url = URL(string: "https://api.github.com/users/TTLBData/repos") else {
            
            completion(.failure(Error.invalidURL))
            return
        }
        
        DownloadManager.sharedInstance.download(url: url, type: [GameSummary].self) { (result) in
            
            completion(result)
        }
    }
    
    override func stored(completion: @escaping (Result<[Game], Swift.Error>) -> Void) {
        
        let fileManager = FileManager.default
        
        guard let gamesFoldersURLs = try? fileManager.contentsOfDirectory(at: gamesFolderURL,
                                                                          includingPropertiesForKeys: [],
                                                                          options: .skipsHiddenFiles) else {
            
            completion(.success([]))
            
            return
        }
        
        var games = [Game]()

        for gamesFoldersURL in gamesFoldersURLs {
            
            if let summary = try? self.loadGameSummary(from: gamesFoldersURL),
               let detachments = try? self.loadDetachments(from: gamesFoldersURL),
               let catalogues = try? self.loadCatalogues(from: gamesFoldersURL),
               catalogues.isEmpty == false {
                
                games.append(Game(id: summary.id, name: summary.name, detachments: detachments, catalogues: catalogues))
            }
        }
        
        completion(.success(games))
    }
    
    override func store(_ obj: Game) throws {
        
    }
    
    
    // MARK: Helper Methods
    
    private func gamesURL(for name: String) -> URL {
        return gamesFolderURL.appendingPathComponent(name)
    }
    
    private func gameSummaryURL(for name: String) -> URL {
        
        return gamesFolderURL.appendingPathComponent(name).appendingPathComponent(name).appendingPathExtension(GamesRepository.gameSummaryExtension)
    }
    
    private func storeGameSummary(_ summary: GameSummary, folderURL: URL) throws {
        
        let summaryData = try JSONEncoder().encode(summary)
        
        try summaryData.write(to: self.gameSummaryURL(for: summary.name))
    }
    
    private func loadGameSummary(from folderURL: URL) throws -> GameSummary? {
        
        let urls = try FileManager.default.contentsOfDirectory(at: folderURL,
                                                               includingPropertiesForKeys: [],
                                                               options: .skipsHiddenFiles)
        
        guard let url = urls.first(where: { $0.pathExtension == GamesRepository.gameSummaryExtension } ) else {
            return nil
        }
        
        return try JSONDecoder().decode(GameSummary.self, from: try Data(contentsOf: url))
    }
    
    private func loadDetachments(from folderURL: URL) throws -> [Detachment] {
        
        let urls = try FileManager.default.contentsOfDirectory(at: folderURL,
                                                               includingPropertiesForKeys: [],
                                                               options: .skipsHiddenFiles)
        
        guard let detachmentURL = urls.first(where: { (url) -> Bool in
            return url.pathExtension == GamesRepository.detachmentsExtension
        }) else {
            // TODO: throw?
            return []
        }
        
        return try JSONDecoder().decode([Detachment].self, from: try Data(contentsOf: detachmentURL))
    }
    
    private func loadCatalogues(from folderURL: URL) throws -> [Catalogue] {
        
        return try load(type: Catalogue.self, pathExtension: GamesRepository.catalogueExtension, from: folderURL)
    }
    
    private func load<T: Codable>(type: T.Type, pathExtension: String, from folderURL: URL) throws -> [T] {
        
        let decoder = JSONDecoder()
        let urls = try FileManager.default.contentsOfDirectory(at: folderURL,
                                                               includingPropertiesForKeys: [],
                                                               options: .skipsHiddenFiles)
        
        return try urls.compactMap { (url) -> T? in
            
            if url.pathExtension == pathExtension {
                
                do {
                    return try decoder.decode(T.self,
                                              from: try Data(contentsOf: url))
                }
                catch {
                    throw error
                }
            }
            
            return nil
        }
    }
}
