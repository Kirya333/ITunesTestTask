//
//  NetworkSession.swift
//  ITunesTestTask
//
//  Created by Кирилл Тарасов on 02.11.2021.
//

import Foundation

class NetworkSession {
    
    static let shared = NetworkSession()
    static var session = URLSession.shared
    static var dataTask: URLSessionDataTask? = nil
    private init() {
        
    }
    
    func performRequest(with url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        NetworkSession.dataTask = URLSession.shared.dataTask(with: url) {
            data, response, error in
            if let error = error {
                print("Network request error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            } else if let response = response as? HTTPURLResponse,
                     response.statusCode == 200 {
               if let data = data {
                completion(.success(data))
               }
            }
        }
        NetworkSession.dataTask!.resume()
    }
}
