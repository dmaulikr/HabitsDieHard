//
//  Habit.swift
//  HabitsDieHard
//
//  Created by Taro Minowa on 8/20/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

import Foundation
import Firebase

class Habit: CustomStringConvertible, Hashable {

    static let rootKey = "habits"

    let userID: String
    let key: String
    let name: String
    
    init(userID: String, key: String, name: String) {
        self.userID = userID
        self.key = key
        self.name = name
    }

    convenience init(userID: String, name: String) {
        let ref = FIRDatabase.database().reference()
        let key = ref.child(Habit.rootKey).child(userID).childByAutoId().key
        self.init(userID: userID, key: key, name: name)
    }

    var description: String { return "Habit {name:\(name)}" }
    var hashValue: Int { return Unmanaged.passUnretained(self).toOpaque().hashValue }

    func save() {
        let ref = FIRDatabase.database().reference()
        let value = [ "created_at": Date().simpleDateKey(), "name": name]
        ref.child("\(Habit.rootKey)/\(userID)/\(key)").setValue(value)
    }
}

func ==(lhs: Habit, rhs: Habit) -> Bool {
    return lhs === rhs
}
