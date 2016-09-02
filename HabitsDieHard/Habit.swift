//
//  Habit.swift
//  HabitsDieHard
//
//  Created by Taro Minowa on 8/20/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

import Foundation
import Firebase

class Habit {
    let name: String
    var done: Bool = false
    init(name: String) {
        self.name = name
    }
}

