//
//  GamesManager.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 06/11/2020.
//

import Foundation

class GamesManager {
    
    // MARK: Enums
    
    enum RepositoryStatus {
        case notDownloaded
        case downloading
        case downloaded
        case failed
        case outOfDate
    }
    
    
    // MARK: GamesManager Variables
    
    static let sharedInstance = GamesManager()
    
    private(set) var activeGames: Set<GameSummary> = []
    private(set) var cachedGames: Set<Game> = []
    
    
    // MARK: Life Cycle Methods
    
    private init() {
        
    }
    
    
    // MARK: Setup Methods
    
    func setup(completion: @escaping () -> Void) {
        
        DispatchQueue.global().async {
            
            GamesRepository().stored { (result) in
                
                switch result {
                
                case .success(let games):
                    
                    self.cachedGames = self.cachedGames.union(games)
                    self.activeGames = self.activeGames.union(games.map( { return GameSummary(id: $0.id, name: $0.name) }))
                case .failure(_): () // TODO: log error
                }
                
                completion()
            }
        }
    }
    
    
    // MARK: Request Data Methods
    
    func requestData(completion: @escaping (_ result: Result<[GameSummary], Error>) -> Void) {
        
        GamesRepository().fetch { (result) in
            completion(result)
        }
    }
    
    
    // MARK: Storage Methods
    
    private func loadStoredData() {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let reposFolder = paths[0].appendingPathComponent("Repositories")
        
        if let folders = try? FileManager.default.contentsOfDirectory(atPath: reposFolder.relativePath) {
            
            for folder in folders {
                
                if folder.hasSuffix("repo") {
                    
                    let repoFolderURL = reposFolder.appendingPathComponent(folder)
                    
                    if let files = try? FileManager.default.contentsOfDirectory(atPath: repoFolderURL.relativePath) {
                        
                        var catalogues = [Catalogue]()
                        
                        for file in files {
                            
                            if file.hasSuffix(".cat") {
                                
                                do {
                                    let catalogueData = try Data(contentsOf: repoFolderURL.appendingPathComponent(file))
                                    let catalogue = try JSONDecoder().decode(Catalogue.self, from: catalogueData)
                                    catalogues.append(catalogue)
                                }
                                catch {
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        
        self.activeGames = []
    }
    
    
    // MARK: Active Repositories Methods
    
    func addActiveGames(_ gameSummaries: [GameSummary]) {
        
        self.activeGames = activeGames.union(gameSummaries)
        
        for gameSummary in gameSummaries {
            
            GamesRepository().download(gameSummary) { (result) in
                
                switch result {
                
                case .success(let game):
                    self.cachedGames.insert(game)
                case .failure(_): () // TODO: Log error
                }
            }
        }
    }
    
    func status(for game: GameSummary) -> RepositoryStatus {
        /*
        if DownloadManager.sharedInstance.isGameDownloaded(game) {
            return .downloaded
        }
        else if DownloadManager.sharedInstance.isGameDownloading(game) {
            return .downloading
        }*/
        
        return .notDownloaded
    }
}
