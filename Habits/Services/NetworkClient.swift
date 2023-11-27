//
//  NetworkClient.swift
//  Habits
//
//  Created by mihail on 25.11.2023.
//

import Foundation

protocol NetworkRouting {
    func fetchGet(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
    func fetch(url: URL,
                   id: Int,
                   _ bool: Bool,
                   boolName: Bools,
                   completion: @escaping (Result<Data, Error>) -> Void)

}

final class NetworkClient: NetworkRouting {
    func fetch(url: URL, id: Int, _ bool: Bool, boolName: Bools, completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parametrs: [String: Any] = if boolName == Bools.bool1 {
             ["id" : id, "bool1" : bool]
        } else if boolName == Bools.bool2 {
             ["id" : id, "bool2" : bool]
        } else {
             ["id" : id, "bool3" : bool]
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parametrs)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.responseError))
                }
                return
            }
            
            if response.statusCode < 200 || response.statusCode >= 300 {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.statusCode))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.emptyData))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
        
        task.resume()
    }
    
    func fetchGet(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.responseError))
                }
                return
            }
            
            if response.statusCode < 200 || response.statusCode >= 300 {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.responseError))
                    print("\(response.statusCode)")
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.emptyData))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
        
        task.resume()
    }
}

enum Bools {
    case bool1
    case bool2
    case bool3
}

enum NetworkError: Error {
    case responseError
    case emptyData
    case statusCode
}
