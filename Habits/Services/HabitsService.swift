//
//  HabitsService.swift
//  Habits
//
//  Created by mihail on 25.11.2023.
//

import Foundation

final class HabitsService {
    let session = URLSession.shared
    
    func fetchHabits(complition: @escaping (Result<[Habit], Error>) -> Void) {
        guard let url = URL(string: "https://ceshops.ru:8443/InfoBase7/hs/api/v1") else { return }
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    complition(.failure(error))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    complition(.failure(NetworkError.responseError))
                }
                return
            }
            
            if 200..<300 ~= response.statusCode {
                do {
                    guard let data = data else {
                        complition(.failure(NetworkError.emptyData))
                        return
                    }
                    
                    let habitsList = try JSONDecoder().decode([Habit].self, from: data)
                    
                    DispatchQueue.main.async {
                        complition(.success(habitsList))
                    }
                } catch {
                    DispatchQueue.main.async {
                        complition(.failure(error))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    complition(.failure(NetworkError.statusCodeError(response.statusCode)))
                }
            }
        }
        task.resume()
    }
}

private enum NetworkError: Error {
    case urlError
    case responseError
    case emptyData
    case statusCodeError(Int)
}
