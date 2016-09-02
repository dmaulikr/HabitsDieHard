//
//  HabitLog.swift
//  HabitsDieHard
//
//  Created by Taro Minowa on 9/2/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

import Foundation
import Firebase

class HabitLog {
    enum HabitLogState: String {
        case Unassigned = "Unassigned"
        case Done = "Done"
        case Missed = "Missed"
    }
    let date: NSDate
    var state: HabitLogState = HabitLogState.Unassigned {
        didSet {
            save()
        }
    }
    init(date: NSDate) {
        self.date = date
    }

    // todo: temporary. should replace with auth
    let userID = "1234"

    func save() {
        let ref = FIRDatabase.database().reference()
        ref.child("habit-logs/\(userID)/\(self.date.simpleDateKey())").setValue(state.rawValue)
    }
}