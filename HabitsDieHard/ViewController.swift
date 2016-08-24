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
    @IBOutlet weak var habitTableView: UITableView!
    private let habits = [Habit(name: "Hello"), Habit(name: "World")]
    private let habitCellIdentifier = "habitCell"
    private let weeklyCellIdentifier = "WeeklyTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        habitTableView.delegate = self
        habitTableView.dataSource = self
        habitTableView.reloadData()

        weeklyTableView.delegate = self
        weeklyTableView.dataSource = self
        weeklyTableView.registerNib(UINib(nibName: "WeeklyTableViewCell", bundle: nil), forCellReuseIdentifier: weeklyCellIdentifier)
        weeklyTableView.reloadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == weeklyTableView {
            return 1
        } else {
            return habits.count
        }
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == weeklyTableView {
            return NSBundle.mainBundle().loadNibNamed("WeeklyHeaderView", owner: self, options: nil).first as? WeeklyHeaderView
        } else {
            return nil
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == weeklyTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier(weeklyCellIdentifier, forIndexPath: indexPath) as! WeeklyTableViewCell
            return cell
        } else {
            var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(habitCellIdentifier)
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: habitCellIdentifier)
            }
            let habit = habits[indexPath.row]
            cell!.textLabel?.text = habit.name
            cell!.backgroundColor = habit.done ? UIColor.greenColor() : UIColor.clearColor()
            return cell!
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let habit: Habit = habits[indexPath.row]
        habit.done = !habit.done
        habitTableView.beginUpdates()
        habitTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        habitTableView.endUpdates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

