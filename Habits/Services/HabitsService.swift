//
//  HabitsService.swift
//  Habits
//
//  Created by mihail on 27.11.2023.
//

import Foundation

protocol HabitsServiceProtocol {
    func fetchHabits()
    func changeCheckmark(model: ActionModel,
                         boolName: Bools,
                         hendler: @escaping () -> Void)
}

class HabitsService: HabitsServiceProtocol {
    static let didChangeNotification = Notification.Name(rawValue: "HabitsListDidChange")
    
    private(set) var habits = [HabitResult]()
    private let session = URLSession.shared
    private var task: URLSessionDataTask? = nil
    func fetchHabits() {
        guard let url = URL(string: "https://ceshops.ru:8443/InfoBase7/hs/api/v1") else { return }
        
        let request = URLRequest(url: url)
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<[HabitResult], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let habits):
                self.habits = habits
                NotificationCenter.default.post(name: HabitsService.didChangeNotification,
                                                object: self,
                                                userInfo: ["Habits" : self.habits])
                
            case .failure(let error):
                print(error)
            }
        }
        
        task.resume()
    }
    
    func changeCheckmark(model: ActionModel,
                         boolName: Bools,
                         hendler: @escaping () -> Void) {
        guard let url = URL(string: "https://ceshops.ru:8443/InfoBase7/hs/api/v1") else { return }
        guard task == nil else { return }
        
        task = session.objectTask(for: url, with: model) { [weak self] (result: Error?) in
            guard let self = self else { return }
            
            switch result {
            case .none:
                if let index = self.habits.firstIndex(where: { $0.id == model.id}) {
                    let habit = self.habits[index]
                    let b1 = boolName == .bool1 ? !habit.bool1 : habit.bool1
                    let b2 = boolName == .bool2 ? !habit.bool2 : habit.bool2
                    let b3 = boolName == .bool3 ? !habit.bool3 : habit.bool3
                    
                    let newHabit = HabitResult(id: habit.id,
                                               name: habit.name,
                                               date: habit.date,
                                               bool1: b1,
                                               bool2: b2,
                                               bool3: b3)
                    self.habits[index] = newHabit
                    print(self.habits[index], "lfaslfasflfls¿")
                    task = nil
                    hendler()
                }
                
            case .some(let error):
                task = nil
                print(error)
            }
        }
        
        task?.resume()
    }
}
