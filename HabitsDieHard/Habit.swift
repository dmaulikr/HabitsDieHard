//
//  Habit.swift
//  HabitsDieHard
//
//  Created by Taro Minowa on 8/20/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

import Foundation

class Habit {
    let name: String
    var done: Bool = false
    init(name: String) {
        self.name = name
    }
}

class HabitLog {
    enum HabitLogState {
        case Unassigned
        case Done
        case Missed
    }
    let date: NSDate
    var state: HabitLogState = HabitLogState.Unassigned
    init(date: NSDate) {
        self.date = date
    }
}