//
//  ViewController.swift
//  HabitsDieHard
//
//  Created by Taro Minowa on 8/19/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var habitTableView: UITableView!
    private let habits = [Habit(name: "Hello"), Habit(name: "World")]
    private let habitCellIdentifier = "habitCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        habitTableView.delegate = self
        habitTableView.dataSource = self
        habitTableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(habitCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: habitCellIdentifier)
        }
        let habit = habits[indexPath.row]
        cell!.textLabel?.text = habit.name
        cell!.backgroundColor = habit.done ? UIColor.greenColor() : UIColor.clearColor()
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let habit: Habit = habits[indexPath.row]
        habit.done = !habit.done
        // todo
        habitTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

