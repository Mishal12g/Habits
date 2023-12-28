//
//  HabitsResult.swift
//  Habits
//
//  Created by mihail on 25.11.2023.
//

import Foundation

struct HabitResult: Codable {
    let id: Int
    let name: String
    let date: String
    var bool1: Bool
    var bool2: Bool
    var bool3: Bool
}
