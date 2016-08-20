//
//  ViewController.swift
//  HabitsDieHard
//
//  Created by Taro Minowa on 8/19/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var taskTableView: UITableView!
    private let tasks = [Habit(name: "Hello"), Habit(name: "World")]
    private let taskCellIdentifier = "taskCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(taskCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: taskCellIdentifier)
        }
        let habit = tasks[indexPath.row]
        cell!.textLabel?.text = habit.name
        cell!.backgroundColor = habit.done ? UIColor.greenColor() : UIColor.clearColor()
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let habit: Habit = tasks[indexPath.row]
        habit.done = !habit.done
        // todo
        taskTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

