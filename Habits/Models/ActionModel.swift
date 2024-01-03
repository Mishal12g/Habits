//
//  ActionModel.swift
//  Habits
//
//  Created by mihail on 29.12.2023.
//

import Foundation

struct ActionModel: Codable {
    let id: Int
    let bool1: Bool?
    let bool2: Bool?
    let bool3: Bool?
    
    init(id: Int,
         bool1: Bool? = nil,
         bool2: Bool? = nil,
         bool3: Bool? = nil
    ) {
        self.id = id
        self.bool1 = bool1
        self.bool2 = bool2
        self.bool3 = bool3
    }
}
