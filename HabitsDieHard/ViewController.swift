//
//  ViewController.swift
//  HabitsDieHard
//
//  Created by Taro Minowa on 8/19/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var weeklyTableView: UITableView!
    private let habits = [Habit(name: "Xcode"), Habit(name: "原稿")]
    private let habitCellIdentifier = "habitCell"
    private let weeklyTitleCellIdentifier = "WeeklyTitleCellIdentifier"
    private let weeklyCellIdentifier = "WeeklyTableViewCell"
    private let habitsWeeklyLog: [[HabitLog]] = [
        [
            HabitLog(date: NSDate(dateString: "2016-08-22")),
            HabitLog(date: NSDate(dateString: "2016-08-23")),
            HabitLog(date: NSDate(dateString: "2016-08-24")),
            HabitLog(date: NSDate(dateString: "2016-08-25")),
            HabitLog(date: NSDate(dateString: "2016-08-26")),
            HabitLog(date: NSDate(dateString: "2016-08-27")),
            HabitLog(date: NSDate(dateString: "2016-08-28"))],
        [
            HabitLog(date: NSDate(dateString: "2016-08-22")),
            HabitLog(date: NSDate(dateString: "2016-08-23")),
            HabitLog(date: NSDate(dateString: "2016-08-24")),
            HabitLog(date: NSDate(dateString: "2016-08-25")),
            HabitLog(date: NSDate(dateString: "2016-08-26")),
            HabitLog(date: NSDate(dateString: "2016-08-27")),
            HabitLog(date: NSDate(dateString: "2016-08-28"))]]

    override func viewDidLoad() {
        super.viewDidLoad()
        weeklyTableView.delegate = self
        weeklyTableView.dataSource = self
        weeklyTableView.registerNib(UINib(nibName: "WeeklyTableViewCell", bundle: nil), forCellReuseIdentifier: weeklyCellIdentifier)
        weeklyTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: weeklyTitleCellIdentifier)
        weeklyTableView.reloadData()
        weeklyTableView.rowHeight = UITableViewAutomaticDimension
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return habitsWeeklyLog.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return NSBundle.mainBundle().loadNibNamed("WeeklyHeaderView", owner: self, options: nil).first as? WeeklyHeaderView
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
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(weeklyTitleCellIdentifier, forIndexPath: indexPath)
            cell.textLabel?.text = habits[indexPath.section].name
            cell.backgroundColor = UIColor.blueColor()
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(weeklyCellIdentifier, forIndexPath: indexPath) as! WeeklyTableViewCell
            // this is temporary faked data
            // todo: Take care of order later
            cell.habitLogsForTargetWeek = habitsWeeklyLog[indexPath.row]
            return cell
        }
    }

    /*
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        <#code#>
    }
*/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

