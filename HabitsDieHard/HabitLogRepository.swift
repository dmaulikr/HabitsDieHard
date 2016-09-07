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

    func habitLogsWithStartDate(startDate: NSDate, endDate: NSDate, complition: ([HabitLog], NSError?) -> Void) {
        let ref = FIRDatabase.database().reference()
        let myHabitLogsRef = ref.child(HabitLog.rootKey).child(self.userID)
        let query = myHabitLogsRef.queryOrderedByChild("date").queryStartingAtValue(startDate.simpleDateKey(), childKey: "date").queryEndingAtValue(endDate.simpleDateKey(), childKey: "date")
        query.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            var habitLogs: [HabitLog] = []
            if let habitLogsDic = snapshot.value as? [String: [String: String]] {
                habitLogsDic.forEach({ (key, valueDic) in
                    habitLogs.append(HabitLog(key: key, userID: self.userID, dateString: valueDic["date"]!, stateString: valueDic["state"]!))
                })
                complition(habitLogs, nil)
            } else {
                complition([], NSError(domain: "todo", code: -1, userInfo: nil))
            }
        })
    }
}
