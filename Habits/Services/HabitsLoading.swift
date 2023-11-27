//
//  HabitsService.swift
//  Habits
//
//  Created by mihail on 25.11.2023.
//

import Foundation

protocol HabitsLoadingProtocol {
    func fetchHabits(handler: @escaping (Result<[Habit], Error>) -> Void)
}

final class HabitsLoading: HabitsLoadingProtocol {
    private let networkClient = NetworkClient()
    
    func fetchHabits(handler: @escaping (Result<[Habit], Error>) -> Void) {
        guard let url = URL(string: "https://ceshops.ru:8443/InfoBase7/hs/api/v1") else { return }
        
        networkClient.fetchGet(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let habitsList = try JSONDecoder().decode([Habit].self, from: data)
                    handler(.success(habitsList))
                } catch {
                    handler(.failure(NetworkError.emptyData))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}


