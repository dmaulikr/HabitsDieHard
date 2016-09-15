//
//  ViewController.swift
//  HabitsDieHard
//
//  Created by Taro Minowa on 8/19/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var weeklyTableView: UITableView!
    fileprivate var habits: [Habit] = []
    fileprivate let habitCellIdentifier = "habitCell"
    fileprivate let weeklyTitleCellIdentifier = "WeeklyTitleCellIdentifier"
    fileprivate let weeklyCellIdentifier = "WeeklyTableViewCell"
    fileprivate let today = Date()
    fileprivate var habitsWeeklyLog: [[HabitLog]] = []
    fileprivate var habitToLog: [Habit: [HabitLog]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        weeklyTableView.delegate = self
        weeklyTableView.dataSource = self
        weeklyTableView.register(UINib(nibName: "WeeklyTableViewCell", bundle: nil), forCellReuseIdentifier: weeklyCellIdentifier)
        weeklyTableView.register(UITableViewCell.self, forCellReuseIdentifier: weeklyTitleCellIdentifier)
        weeklyTableView.reloadData()
        weeklyTableView.rowHeight = UITableViewAutomaticDimension
        weeklyTableView.separatorStyle = UITableViewCellSeparatorStyle.none

/*
        let ref = FIRDatabase.database().reference()
        let myHabitLogsRef = ref.child("habits").child("1234")
        let key = myHabitLogsRef.childByAutoId().key
        let value = [ "created_at": NSDate().simpleDateKey(), "name": "Jogging"]
        myHabitLogsRef.child(key).setValue(value)
*/

        // userid
        // repository
        // remove done var
        // save
        // key
        let ref = FIRDatabase.database().reference()
        let myHabitLogsRef = ref.child("habits").child("1234")
        let query = myHabitLogsRef.queryOrdered(byChild: "name")
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            var habits: [Habit] = []
            for case let habitLogSnapshot as FIRDataSnapshot in snapshot.children {
                if let habitLogDic = habitLogSnapshot.value as? [String: String] {
                    habits.append(Habit(key: habitLogSnapshot.key, name: habitLogDic["name"]!))
                }
            }
            // habit types
            // auth
            self.habits = habits
            let startDate = self.today.getSunday()
            let endDate = startDate.dateByAdding(delta: 6)
            for habit in habits {
                HabitLogRepository(userID: "1234").getFilledRangeWithHabit(habit, startDate: startDate, endDate: endDate) { (habitLogs, error) in
                    if error == nil {

                        self.habitToLog[habit] = habitLogs
//                        // Ah todo
//                        self.habitsWeeklyLog.append(habitLogs)

//                        print("repo=\(habitLogs)")
                        self.weeklyTableView.reloadData()
                    } else {
                        // todo
                    }
                }
            }
        })


    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return habits.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if let headerView = Bundle.main.loadNibNamed("WeeklyHeaderView", owner: self, options: nil)?.first as? WeeklyHeaderView {
                let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
                let components = calendar.dateComponents([.weekday], from: today)
                headerView.dayOfWeek = components.weekday!
                return headerView
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: weeklyTitleCellIdentifier, for: indexPath)
            cell.textLabel?.text = habits[(indexPath as NSIndexPath).section].name
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: weeklyCellIdentifier, for: indexPath) as! WeeklyTableViewCell
            let habit: Habit = habits[(indexPath as NSIndexPath).section]
            if let habitLogs: [HabitLog] = habitToLog[habit] {
                cell.habitLogsForTargetWeek = habitLogs
            }
            return cell
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

