//
//  GamesManager.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 06/11/2020.
//

import Foundation

class GamesManager {
    
    // MARK: Enums
    
    enum GamesStatus {
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
    
    
    // MARK: Helper Methods
    
    func status(for game: GameSummary) -> GamesStatus {
        
        if cachedGames.contains(where: { (cachedGame) -> Bool in
            cachedGame.id == game.id
        }) {
            return .downloaded
        }
        
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
