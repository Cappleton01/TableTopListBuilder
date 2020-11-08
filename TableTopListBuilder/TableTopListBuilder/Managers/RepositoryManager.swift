//
//  RepositoryManager.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 06/11/2020.
//

import Foundation

class RepositoryManager {
    
    // MARK: Enums
    
    enum Error: Swift.Error {
        case invalidURL
        case httpRequestFailed(_ code: Int?)
        case decodeFailure
    }
    
    enum RepositoryStatus {
        case notDownloaded
        case downloading
        case downloaded
        case failed
        case outOfDate
    }
    
    
    // MARK: RepositoryManager Variables
    
    static let sharedInstance = RepositoryManager()
    
    private(set) var activeRepositories: Set<Repository> = []
    
    
    // MARK: Life Cycle Methods
    
    private init() {
        
    }
    
    
    // MARK: Setup Methods
    
    func setup(completion: @escaping () -> Void) {
        
        DispatchQueue.global().async {
            
            self.loadStoredData()
            completion()
        }
    }
    
    
    // MARK: Request Data Methods
    
    func requestData(completion: @escaping (_ result: Result<[Repository], Error>) -> Void) {
        
        guard let url = URL(string: "https://api.github.com/users/TTLBData/repos") else {
            
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            
            self.handleRequestDataCompletion(data: data, response: response, error: error, completion: completion)
            
        }.resume()
    }
    
    private func handleRequestDataCompletion(data: Data?, response: URLResponse?, error: Swift.Error?, completion: @escaping (_ result: Result<[Repository], Error>) -> Void) {
        
        if let response = response as? HTTPURLResponse, response.statusCode >= 200, response.statusCode < 300, let data = data {
            
            do {
                completion(.success(try JSONDecoder().decode([Repository].self, from: data)))
            }
            catch {
                completion(.failure(.decodeFailure))
            }
        }
        else {

            if let response = response as? HTTPURLResponse {

                NSLog("Data task callback responded with status code: \(response.statusCode)", "")

                if let data = data {

                    NSLog("Data task callback responded with data: \(String(data: data, encoding: .utf8) ?? "")", "")
                }
                
                completion(.failure(.httpRequestFailed(response.statusCode)))
            }
            else {
                completion(.failure(.httpRequestFailed(nil)))
            }
        }
    }
    
    
    // MARK: Storage Methods
    
    private func loadStoredData() {
        
        // TODO: check for data
        Thread.sleep(forTimeInterval: 1)
        
        self.activeRepositories = []
    }
    
    
    // MARK: Active Repositories Methods
    
    func addActiveRepositories(_ repos: [Repository]) {
        
        self.activeRepositories = activeRepositories.union(repos)
        DownloadManager.sharedInstance.downloadRepositories(repos)
    }
    
    func status(for repo: Repository) -> RepositoryStatus {
        
        if DownloadManager.sharedInstance.isRepositoryDownloaded(repo) {
            return .downloaded
        }
        else if DownloadManager.sharedInstance.isRepositoryDownloading(repo) {
            return .downloading
        }
        
        return .notDownloaded
    }
}
