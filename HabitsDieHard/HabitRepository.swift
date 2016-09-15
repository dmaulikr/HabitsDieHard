//
//  HabitRepository.swift
//  HabitsDieHard
//
//  Created by Taro Minowa on 9/15/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

import Foundation
import Firebase

class HabitRepository {

    fileprivate let userID: String

    init(userID: String) {
        self.userID = userID
    }

    func getHabits(complition: @escaping ([Habit], NSError?) -> Void) {
        let ref = FIRDatabase.database().reference()
        let myHabitLogsRef = ref.child("habits").child(userID)
        let query = myHabitLogsRef.queryOrdered(byChild: "name")
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            var habits: [Habit] = []
            for case let habitLogSnapshot as FIRDataSnapshot in snapshot.children {
                if let habitLogDic = habitLogSnapshot.value as? [String: String] {
                    habits.append(Habit(key: habitLogSnapshot.key, name: habitLogDic["name"]!))
                }
            }
            complition(habits, nil)
        })
    }
}
