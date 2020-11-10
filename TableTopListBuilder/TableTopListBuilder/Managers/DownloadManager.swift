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
    
    
    // MARK: DownloadManager Variables
    
    static let sharedInstance = DownloadManager()
    
    private static let zipExtension = "zip"
    
    private let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    
    
    // MARK: Life Cycle Methods
    
    private init() {
        
    }
    
    
    // MARK: Download Methods
    
    func download<T: Codable>(url: URL, type: T.Type, completion: @escaping (Result<T, Swift.Error>) -> Void) {
        
        let task = session.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            
            self.handleDataTaskCallback(data: data, response: response, error: error) { (data) in
                
                do {
                    completion(.success(try JSONDecoder().decode(T.self, from: data)))
                }
                catch {
                    // TOOD: custom error
                    completion(.failure(error))
                }
            } failureHandler: { (error) in
                completion(.failure(Error.unknown))
            }
        }
        
        task.resume()
    }
    
    func downloadZip(url: URL, extractionURL: URL, completion: @escaping (Result<URL, Swift.Error>) -> Void) {
        
        session.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            
            self.handleDataTaskCallback(data: data, response: response, error: error) { (data) in
                
                do {
                    let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
                    let filePath = paths[0].appendingPathComponent(UUID().uuidString).appendingPathExtension(DownloadManager.zipExtension)
                    
                    try data.write(to: filePath)
                    
                    var isRootFolder = true
                    
                    try Zip.unzipFile(filePath, destination: extractionURL, overwrite: true, password: nil, progress: nil) { (unzippedResult) in
                        
                        if isRootFolder {
                            isRootFolder = false
                        }
                        else {
                            NSLog("unzipped file to \(unzippedResult.relativePath)", "")
                            
                            do {
                                try FileManager.default.moveItem(atPath: unzippedResult.relativePath, toPath: extractionURL.appendingPathComponent(unzippedResult.lastPathComponent).relativePath)
                            }
                            catch {
                                // TODO: Error
                            }
                        }
                    }
                    
                    completion(.success(extractionURL))
                }
                catch {
                    
                    NSLog("\(error.localizedDescription)", "")
                    // TOOD: custom error
                    completion(.failure(Error.unknown))
                }
                
            } failureHandler: { (error) in
                
                completion(.failure(Error.unknown))
            }
        }.resume()
    }
    
    private func handleDataTaskCallback(data: Data?, response: URLResponse?, error: Swift.Error?, successHandler: (Data) -> Void, failureHandler:(Swift.Error?) -> Void) {
        
        if let response = response as? HTTPURLResponse, response.statusCode >= 200, response.statusCode < 300, let data = data {
            
            successHandler(data)
        }
        else {

            if let response = response as? HTTPURLResponse {

                NSLog("Data task callback responded with status code: \(response.statusCode)", "")

                if let data = data {
                    NSLog("Data task callback responded with data: \(String(data: data, encoding: .utf8) ?? "")", "")
                }
                
                failureHandler(error)
            }
            else {
                
                failureHandler(error)
            }
        }
    }
}
