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

    let key: String
    let name: String
    
    init(key: String, name: String) {
        self.key = key
        self.name = name
    }

    var description: String { return "Habit {name:\(name)}" }
    var hashValue: Int { return Unmanaged.passUnretained(self).toOpaque().hashValue }

// todo Save
//    let ref = FIRDatabase.database().reference()
//    let key = ref.child(Habit.rootKey).child(user!.uid).childByAutoId().key
//    let value = [ "created_at": Date().simpleDateKey(), "name": "Swift"]
//    ref.child("\(Habit.rootKey)/\(user!.uid)/\(key)").setValue(value)

}

func ==(lhs: Habit, rhs: Habit) -> Bool {
    return lhs === rhs
}
