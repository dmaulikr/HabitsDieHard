//
//  HabitLogRepository.swift
//  HabitsDieHard
//
//  Created by Taro Minowa on 9/6/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

import Foundation
import Firebase

class HabitLogRepository {


    let userID: String

    init(userID: String) {
        self.userID = userID
    }

    func getRangeWithHabit(_ habit: Habit, startDate: Date, endDate: Date, complition: @escaping ([HabitLog], NSError?) -> Void) {
        let ref = FIRDatabase.database().reference()
        let myHabitLogsRef = ref.child(HabitLog.rootKey).child(self.userID).child(habit.key)

        // don't use "2016-09-16" format, - would be recognized as minus.
        let query = myHabitLogsRef.queryOrdered(byChild: "date").queryStarting(atValue: startDate.simpleDateKey()).queryEnding(atValue: endDate.simpleDateKey())
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            var habitLogs: [HabitLog] = []

            // we are using children enumerator to keep order
            for case let habitLogSnapshot as FIRDataSnapshot in snapshot.children {
                if let habitLogDic = habitLogSnapshot.value as? [String: String] {
                    habitLogs.append(HabitLog(key: habitLogSnapshot.key, habitKey: habit.key, userID: self.userID, dateString: habitLogDic["date"]!, stateString: habitLogDic["state"]!))
                }
            }
            complition(habitLogs, nil)
        })
    }

    func getFilledRangeWithHabit(_ habit: Habit, startDate: Date, endDate: Date, complition: @escaping ([HabitLog], NSError?) -> Void) {
        getRangeWithHabit(habit, startDate: startDate, endDate: endDate) { (habitLogs, error) in
            var ret: [HabitLog] = []
            var index = 0
            var targetDate = startDate
            while targetDate.compare(endDate) != ComparisonResult.orderedDescending {
                if index >= habitLogs.count {
                    ret.append(HabitLog(habitKey: habit.key, userID: self.userID, date: targetDate ))
                } else if habitLogs[index].date.simpleDateKey() == targetDate.simpleDateKey() {
                    ret.append(habitLogs[index])
                    index += 1
                } else {
                    ret.append(HabitLog(habitKey: habit.key, userID: self.userID, date: targetDate))
                }
                targetDate = targetDate.dateByAdding(delta: 1)
            }
            complition(ret, nil)
        }
    }
}
