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

    func habitLogsWithStartDate(startDate: NSDate, endDate: NSDate, complition: ([HabitLog], NSError?) -> Void) {
        let ref = FIRDatabase.database().reference()
        let myHabitLogsRef = ref.child(HabitLog.rootKey).child(self.userID)
        let query = myHabitLogsRef.queryOrderedByKey().queryStartingAtValue(startDate.simpleDateKey()).queryEndingAtValue(endDate.simpleDateKey())
        query.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            var habitLogs: [HabitLog] = []
            if let habitLogsDic = snapshot.value as? [String: String] {
                habitLogsDic.forEach({ (dateString, stateString) in
                    habitLogs.append(HabitLog(userID: self.userID, dateString: dateString, stateString: stateString))
                })
                complition(habitLogs, nil)
            } else {
                complition([], NSError(domain: "todo", code: -1, userInfo: nil))
            }
        })
    }
}
