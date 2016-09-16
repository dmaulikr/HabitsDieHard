//
//  HabitLog.swift
//  HabitsDieHard
//
//  Created by Taro Minowa on 9/2/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

import Foundation
import Firebase

class HabitLog: CustomStringConvertible {
    static let rootKey = "habit-logs"
    enum HabitLogState: String {
        case Unassigned = "Unassigned"
        case Done = "Done"
        case Missed = "Missed"
    }

    let date: Date
    fileprivate let userID: String
    fileprivate var key: String?
    fileprivate let habitKey: String

    var state: HabitLogState = HabitLogState.Unassigned {
        didSet {
            save()
        }
    }

    init(key: String?, habitKey: String, userID: String, date: Date, state: HabitLogState) {
        self.key = key
        self.habitKey = habitKey
        self.userID = userID
        self.state = state
        self.date = date
    }

    convenience init(habitKey: String, userID: String, date: Date) {
        self.init(key: nil, habitKey: habitKey, userID: userID, date: date, state: .Unassigned)
    }

    convenience init(key: String, habitKey: String, userID: String, dateString: String, stateString: String) {
        if let habitLogState = HabitLogState(rawValue: stateString) {
            self.init(key: key, habitKey: habitKey, userID: userID, date: Date(dateString: dateString), state: habitLogState)
        } else {
            self.init(key: key, habitKey: habitKey, userID: userID, date: Date(dateString: dateString), state: .Unassigned)
        }
    }

    var description: String { return "userID:\(userID) date:\(date.simpleDateKey()) state:\(state.rawValue)" }

    func save() {
        let ref = FIRDatabase.database().reference()
        if self.key == nil {
            self.key = ref.child(HabitLog.rootKey).child(self.userID).child(self.habitKey).childByAutoId().key
        }
        let value = [ "date": self.date.simpleDateKey(), "state": state.rawValue]
        ref.child("\(HabitLog.rootKey)/\(userID)/\(self.habitKey)/\(self.key!)").setValue(value)
    }
}
