//
//  DownloadManager.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 07/11/2020.
//

import Foundation

import Zip

class DownloadManager {
    
    enum Error: Swift.Error {
        
        case unknown
        case noReleases
    }
    
    private struct RepositoryDownload {
        
        let repo: Repository
        let task: URLSessionDataTask
    }
    
    
    // MARK: DownloadManager Variables
    
    static let sharedInstance = DownloadManager()
    
    private static let repoExtension = "repo"
    private static let catalogueExtension = "cat"
    private static let zipExtension = "zip"
    
    private let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    private var repositoryDownloads: [RepositoryDownload] = []
    private var failedRepositoryDownloads: [RepositoryDownload] = []
    
    
    // MARK: Life Cycle Methods
    
    private init() {
        
    }
    
    
    // MARK: Download Methods
    
    func downloadRepositories(_ repos: [Repository]) {
        
        for repo in repos {
            
            if let url = URL(string: "https://api.github.com/repos/TTLBData/\(repo.name)/releases/latest") {
                
                let task = session.dataTask(with: URLRequest(url: url)) { (data, response, error) in
                    
                    self.downloadRepositoriesHandler(repo: repo, data: data, response: response, error: error)
                }
                
                let download = RepositoryDownload(repo: repo, task: task)
                repositoryDownloads.append(download)
                
                task.resume()
            }
            else {
                // TOOD: Error?
            }
        }
    }
    
    private func downloadRepositoriesHandler(repo: Repository, data: Data?, response: URLResponse?, error: Swift.Error?) {
        
        if let response = response as? HTTPURLResponse, response.statusCode >= 200, response.statusCode < 300, let data = data {
            
            do {
                let repoRelease = try JSONDecoder().decode(RepositoryRelease.self, from: data)
                
                self.downloadRelease(repoRelease, repo: repo)
            }
            catch {
                // TOOD: Error?
            }
        }
        else {

            if let response = response as? HTTPURLResponse {

                NSLog("Data task callback responded with status code: \(response.statusCode)", "")

                if let data = data {

                    NSLog("Data task callback responded with data: \(String(data: data, encoding: .utf8) ?? "")", "")
                }
                // TOOD: Error?
            }
            else {
                // TOOD: Error?
            }
        }
    }
    
    private func downloadRelease(_ release: RepositoryRelease, repo: Repository) {
        
        if let url = URL(string: release.zipURL) {
            
            session.dataTask(with: URLRequest(url: url)) { (data, response, error) in
                
                if let response = response as? HTTPURLResponse, response.statusCode >= 200, response.statusCode < 300, let data = data {
                    
                    do {
                        let filePath = self.url(for: repo, pathExtension: DownloadManager.zipExtension)
                        let destinationPath = self.url(for: repo, pathExtension: DownloadManager.repoExtension)
                        
                        try data.write(to: filePath)
                        
                        try Zip.unzipFile(filePath, destination: destinationPath, overwrite: true, password: nil, progress: nil) { (unzippedResult) in
                            
                            do {
                                let rootFolders = try FileManager.default.contentsOfDirectory(atPath: destinationPath.relativePath)
                                
                                if let rootFolder = rootFolders.first {
                                    
                                    let rootFolderURL = destinationPath.appendingPathComponent(rootFolder)
                                    
                                    let files = try FileManager.default.contentsOfDirectory(atPath: rootFolderURL.relativePath)
                                    
                                    var catalogues = [Catalogue]()
                                    
                                    for file in files {
                                        
                                        if file.hasSuffix(".cat") {
                                            
                                            do {
                                                let catalogueData = try Data(contentsOf: rootFolderURL.appendingPathComponent(file))
                                                let catalogue = try JSONDecoder().decode(Catalogue.self, from: catalogueData)
                                                catalogues.append(catalogue)
                                            }
                                            catch {
                                                
                                            }
                                        }
                                    }
                                }
                                
                                //let unzippedData = try Data(contentsOf: unzippedResult)
                                
                                //NSLog(String(data: unzippedData, encoding: .utf8) ?? "", "")
                            }
                            catch {
                                
                                NSLog("\(error.localizedDescription)", "")
                            }
                        }
                        
                        //let repoRelease = try JSONDecoder().decode(RepositoryRelease.self, from: data)
                        //completion(.success(repos))
                    }
                    catch {
                        
                        NSLog("\(error.localizedDescription)", "")
                        //completion(.failure(.decodeFailure))
                    }
                }
                else {

                    if let response = response as? HTTPURLResponse {

                        NSLog("Data task callback responded with status code: \(response.statusCode)", "")

                        if let data = data {

                            NSLog("Data task callback responded with data: \(String(data: data, encoding: .utf8) ?? "")", "")
                        }
                        
                        //completion(.failure(.httpRequestFailed(response.statusCode)))
                    }
                    else {
                        //completion(.failure(.httpRequestFailed(nil)))
                    }
                }
            }.resume()
        }
        else {
            // TOOD: Error?
        }
    }
    
    
    // MARK: Helper Methods
    
    private func url(for repo: Repository, pathExtension: String) -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0].appendingPathComponent(repo.name).appendingPathExtension(pathExtension)
    }
    
    private func removeRepositoryDownload(for repo: Repository) {
        
        self.repositoryDownloads.removeAll { (download) -> Bool in
            download.repo.id == repo.id
        }
    }
    
    func isRepositoryDownloaded(_ repo: Repository) -> Bool {
        
        return FileManager.default.fileExists(atPath: url(for: repo, pathExtension: DownloadManager.repoExtension).relativePath)
    }
    
    func isRepositoryDownloading(_ repo: Repository) -> Bool {
        
        return repositoryDownloads.contains { (download) -> Bool in
            download.repo.id == repo.id
        }
    }
}
