//
//  ViewController.swift
//  HabitsDieHard
//
//  Created by Taro Minowa on 8/19/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

import UIKit
import Firebase

// todo user id as key
class HabitLogRepository {
    let userID: String
    init(userID: String) {
        self.userID = userID
    }
    func habitLogsWithStartDate(startDate: NSDate, endDate: NSDate, complition: ([HabitLog], NSError?) -> Void) {
        let ref = FIRDatabase.database().reference()
        let myHabitLogsRef = ref.child("habit-logs").child(self.userID)
        let query = myHabitLogsRef.queryOrderedByKey().queryStartingAtValue(startDate.simpleDateKey()).queryEndingAtValue(endDate.simpleDateKey())
        query.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            var habitLogs: [HabitLog] = []
            if let habitLogsDic = snapshot.value as? [String: String] {
                habitLogsDic.forEach({ (dateString, stateString) in
                    habitLogs.append(HabitLog(dateString: dateString, stateString: stateString))
                })
                complition(habitLogs, nil)
            } else {
                complition([], NSError(domain: "todo", code: -1, userInfo: nil))
            }
        })
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var weeklyTableView: UITableView!
    private let habits = [Habit(name: "Xcode"), Habit(name: "原稿")]
    private let habitCellIdentifier = "habitCell"
    private let weeklyTitleCellIdentifier = "WeeklyTitleCellIdentifier"
    private let weeklyCellIdentifier = "WeeklyTableViewCell"
    private let today = NSDate()
    private var habitsWeeklyLog: [[HabitLog]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        weeklyTableView.delegate = self
        weeklyTableView.dataSource = self
        weeklyTableView.registerNib(UINib(nibName: "WeeklyTableViewCell", bundle: nil), forCellReuseIdentifier: weeklyCellIdentifier)
        weeklyTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: weeklyTitleCellIdentifier)
        weeklyTableView.reloadData()
        weeklyTableView.rowHeight = UITableViewAutomaticDimension
        weeklyTableView.separatorStyle = UITableViewCellSeparatorStyle.None

        for _ in 0...habits.count - 1 {
            habitsWeeklyLog.append(
            today.getWholeWeekDates().map({ (date) -> HabitLog in
                return HabitLog(date: date)
            }))
        }
        // testing
        // move repository to new file
        // fill gap
        // adjust date

        HabitLogRepository(userID: "1234").habitLogsWithStartDate( NSDate(dateString: "2016-09-04"), endDate: NSDate(dateString: "2016-09-05")) { (habitLogs, error) in
            if error == nil {
                NSLog("repo=%@", habitLogs)
            } else {
                // todo
            }
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return habitsWeeklyLog.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if let headerView = NSBundle.mainBundle().loadNibNamed("WeeklyHeaderView", owner: self, options: nil).first as? WeeklyHeaderView {
                let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
                let components = calendar.components(.Weekday, fromDate: today)
                headerView.dayOfWeek = components.weekday
                return headerView
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(weeklyTitleCellIdentifier, forIndexPath: indexPath)
            cell.textLabel?.text = habits[indexPath.section].name
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(weeklyCellIdentifier, forIndexPath: indexPath) as! WeeklyTableViewCell
            cell.habitLogsForTargetWeek = habitsWeeklyLog[indexPath.row]
            return cell
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

