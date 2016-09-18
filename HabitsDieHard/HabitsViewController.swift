//
//  HabitsViewController.swift
//  HabitsDieHard
//
//  Created by Taro Minowa on 8/19/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class HabitsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    fileprivate let habitCellIdentifier = "habitCell"
    fileprivate let weeklyTitleCellIdentifier = "WeeklyTitleCellIdentifier"
    fileprivate let weeklyCellIdentifier = "WeeklyTableViewCell"

    fileprivate var weeklyTableView: UITableView!
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    fileprivate var habits: [Habit] = []
    fileprivate var habitToLog: [Habit: [HabitLog]] = [:]
    fileprivate let firstSection = 0
    fileprivate var user: FIRUser?
    let targetDate: Date

    init(_ targetDate: Date) {
        self.targetDate = targetDate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        weeklyTableView = UITableView(frame: self.view.frame, style: .plain)
        let topInset: CGFloat = 64.0
        weeklyTableView.contentInset = UIEdgeInsetsMake(topInset, 0.0, 0.0, 0.0);
        weeklyTableView.scrollIndicatorInsets = UIEdgeInsetsMake(topInset, 0.0, 0.0, 0.0);
        view.addSubview(weeklyTableView)
        weeklyTableView.delegate = self
        weeklyTableView.dataSource = self
        weeklyTableView.register(UINib(nibName: "WeeklyTableViewCell", bundle: nil), forCellReuseIdentifier: weeklyCellIdentifier)
        weeklyTableView.register(UITableViewCell.self, forCellReuseIdentifier: weeklyTitleCellIdentifier)
        weeklyTableView.reloadData()
        weeklyTableView.rowHeight = UITableViewAutomaticDimension
        weeklyTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        weeklyTableView.backgroundView = self.activityIndicatorView

        self.user = FIRAuth.auth()?.currentUser
        assert(self.user != nil)

//        self.parent?.title = titleString()
        // Todo
        // title should be in UINavC
        // +
        // help message when empty
        // Save Habits
        // Make font smaller
    }

    override func viewWillAppear(_ animated: Bool) {
        self.loadHabits()
    }

    private func loadHabits() {
        if user != nil {

            // todo Save
/*
            let ref = FIRDatabase.database().reference()
            let key = ref.child(Habit.rootKey).child(user!.uid).childByAutoId().key
            ref.child("\(Habit.rootKey)/\(user!.uid)/\(key)").setValue([ "created_at": Date().simpleDateKey(), "name": "Jogging"])

            let ref2 = FIRDatabase.database().reference()
            let key2 = ref2.child(Habit.rootKey).child(user!.uid).childByAutoId().key
            ref2.child("\(Habit.rootKey)/\(user!.uid)/\(key2)").setValue([ "created_at": Date().simpleDateKey(), "name": "Swift"])
*/
            self.activityIndicatorView.startAnimating()
            HabitRepository(userID: user!.uid).getHabits { (habits, error) in
                self.habits = habits
                let startDate = self.targetDate.getSunday()
                let endDate = startDate.dateByAdding(delta: 6)
                for habit in habits {
                    HabitLogRepository(userID: self.user!.uid).getFilledRangeWithHabit(habit, startDate: startDate, endDate: endDate) { (habitLogs, error) in
                        if error == nil {
                            self.habitToLog[habit] = habitLogs
                            self.weeklyTableView.reloadData()
                        } else {
                            // todo
                        }
                        self.activityIndicatorView.stopAnimating()
                    }
                }
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return habits.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == firstSection {
            if let headerView = Bundle.main.loadNibNamed("WeeklyHeaderView", owner: self, options: nil)?.first as? WeeklyHeaderView {
                headerView.targetDate = targetDate          
                return headerView
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == firstSection {
            return 60
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: weeklyTitleCellIdentifier, for: indexPath)
            cell.textLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
            cell.textLabel?.text = habits[(indexPath as NSIndexPath).section].name
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: weeklyCellIdentifier, for: indexPath) as! WeeklyTableViewCell
            let habit: Habit = habits[indexPath.section]
            if let habitLogs: [HabitLog] = habitToLog[habit] {
                cell.habitLogsForTargetWeek = habitLogs
            }
            return cell
        }
    }

    func tableView(_: UITableView, shouldHighlightRowAt: IndexPath) -> Bool {
        return false
    }
}

