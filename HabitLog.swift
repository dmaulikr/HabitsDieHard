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
    let userID: String
    let date: NSDate
    var state: HabitLogState = HabitLogState.Unassigned {
        didSet {
            save()
        }
    }

    init(userID: String, date: NSDate, state: HabitLogState) {
        self.userID = userID
        self.state = state
        self.date = date
    }

    convenience init(userID: String, date: NSDate) {
        self.init(userID: userID, date: date, state: .Unassigned)
    }

    convenience init(userID: String, dateString: String, stateString: String) {
        if let habitLogState = HabitLogState(rawValue: stateString) {
            self.init(userID: userID, date: NSDate(dateString: dateString), state: habitLogState)
        } else {
            self.init(userID: userID, date: NSDate(dateString: dateString), state: .Unassigned)
        }
    }

    var description: String { return "userID:\(userID) date:\(date.simpleDateKey()) state:\(state.rawValue)" }


//    convenience init(snapshot: FIRDataSnapshot) {
//        let dateString = snapshot.key
//        if let statusString = snapshot.value as? String, habitLogState = HabitLogState(rawValue: statusString) {
//            self.init(userID: userID, date: NSDate(dateString: dateString), state: habitLogState)
//        } else {
//            self.init(userID: userID, date: NSDate(dateString: dateString), state: .Unassigned)
//        }
//    }
//
//    // todo: temporary. should replace with auth
//    let userID = "1234"

    func save() {
        let ref = FIRDatabase.database().reference()
        ref.child("\(HabitLog.rootKey)/\(userID)/\(self.date.simpleDateKey())").setValue(state.rawValue)
    }
}
