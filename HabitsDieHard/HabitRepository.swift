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
    static let rootKey = "habits"

    fileprivate let userID: String

    init(userID: String) {
        self.userID = userID
    }

    func getHabits(complition: @escaping ([Habit], NSError?) -> Void) {
        let ref = FIRDatabase.database().reference()
        let habitsRef = ref.child(HabitRepository.rootKey).child(userID)
        let query = habitsRef.queryOrdered(byChild: "name")
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            var habits: [Habit] = []
            for case let habitSnapshot as FIRDataSnapshot in snapshot.children {
                if let habitDic = habitSnapshot.value as? [String: String] {
                    habits.append(Habit(key: habitSnapshot.key, name: habitDic["name"]!))
                }
            }
            complition(habits, nil)
        })
    }
}
