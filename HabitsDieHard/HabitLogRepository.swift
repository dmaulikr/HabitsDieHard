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

    // todo constant keys
    // check order
    // tidy
    let userID: String

    init(userID: String) {
        self.userID = userID
    }

    func getWithStartDate(startDate: NSDate, endDate: NSDate, complition: ([HabitLog], NSError?) -> Void) {
        let ref = FIRDatabase.database().reference()
        let myHabitLogsRef = ref.child(HabitLog.rootKey).child(self.userID)
        let query = myHabitLogsRef.queryOrderedByChild("date").queryStartingAtValue(startDate.simpleDateKey()).queryEndingAtValue(endDate.simpleDateKey())
        query.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            var habitLogs: [HabitLog] = []

            // we are using children enumerator to keep order
            for case let habitLogSnapshot as FIRDataSnapshot in snapshot.children {
                if let habitLogDic = habitLogSnapshot.value as? [String: String] {
                    habitLogs.append(HabitLog(key: habitLogSnapshot.key, userID: self.userID, dateString: habitLogDic["date"]!, stateString: habitLogDic["state"]!))
                }
            }
            complition(habitLogs, nil)
        })
    }

    func getFilledRangeWithStartDate(startDate: NSDate, endDate: NSDate, complition: ([HabitLog], NSError?) -> Void) {
        getWithStartDate(startDate, endDate: endDate) { (habitLogs, error) in
            var ret: [HabitLog] = []
            var index = 0
            var targetDate = startDate
            while targetDate.compare(endDate) != NSComparisonResult.OrderedDescending {
                if index >= habitLogs.count {
                    ret.append(HabitLog(userID: self.userID, date: targetDate))
                } else if habitLogs[index].date.simpleDateKey() == targetDate.simpleDateKey() {
                    ret.append(habitLogs[index])
                    index += 1
                } else {
                    ret.append(HabitLog(userID: self.userID, date: targetDate))
                }
                targetDate = targetDate.dateByAdding(1)
            }
            complition(ret, nil)
        }
    }
}
