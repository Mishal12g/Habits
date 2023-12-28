//
//  HabitsService.swift
//  Habits
//
//  Created by mihail on 27.11.2023.
//

import Foundation

protocol HabitsServiceProtocol {
    func fetchHabits(handler: @escaping (Result<[HabitResult], Error>) -> Void)
    func changeCheckmark(id: Int,
                      bool: Bool,
                      boolName: Bools,
                      handler: @escaping (Result<Data, Error>) -> Void)
}

class HabitsService: HabitsServiceProtocol {
    private let networkClient = NetworkClient()
    
    func fetchHabits(handler: @escaping (Result<[HabitResult], Error>) -> Void) {
        guard let url = URL(string: "https://ceshops.ru:8443/InfoBase7/hs/api/v1") else { return }
        
        networkClient.fetchGet(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let habitsList = try JSONDecoder().decode([HabitResult].self, from: data)
                    handler(.success(habitsList))
                } catch {
                    handler(.failure(NetworkError.emptyData))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    func changeCheckmark(id: Int,
                      bool: Bool,
                      boolName: Bools,
                      handler: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "https://ceshops.ru:8443/InfoBase7/hs/api/v1") else { return }
        
        networkClient.fetch(url: url,
                            id: id, bool, boolName: boolName) { result in
            switch result {
            case .success(let data):
                handler(.success(data))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
