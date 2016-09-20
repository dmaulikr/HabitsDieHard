//
//  HabitsPageViewController.swift
//  HabitsDieHard
//
//  Created by Taro Minowa on 9/18/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class HabitsPageViewController: UIPageViewController {

    fileprivate var dateToVC: [String: HabitsViewController] = [:]
    fileprivate var user: FIRUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers([getViewContrller(byDate: Date())], direction: .forward, animated: true, completion: nil)
        automaticallyAdjustsScrollViewInsets = false
        dataSource = self
        delegate = self
        title = title(date: Date())

        self.user = FIRAuth.auth()?.currentUser
        assert(self.user != nil)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }

    func addTapped() {

        let alertController = UIAlertController(title: "Add New Habit", message: "", preferredStyle: UIAlertControllerStyle.alert)

        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            alert -> Void in

            if let textFields = alertController.textFields {
                if let text = textFields[0].text {
                    if !text.isEmpty {
                        let habit = Habit(userID: self.user!.uid , name: text)
                        habit.save()
                    }
                }
            }
            // todo error case
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
        })

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Habit Name"
        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        self.present(alertController, animated: true, completion: nil)
    }


    func title(date: Date) -> String {
        let today = Date()
        if date.getSunday() == today.getSunday() {
            return "This Week"
        } else if date.getSunday() == today.lastWeek().getSunday() {
            return "Last Week"
        } else {
            return "Week of \(date.simpleDateKey())"
        }
    }

    func getViewContrller(byDate: Date) -> HabitsViewController {
        if let vc = dateToVC[byDate.simpleDateKey()] {
            return vc
        } else {
            let vc = HabitsViewController(byDate)
            dateToVC[byDate.simpleDateKey()] = vc
            return vc
        }
    }
}

extension HabitsPageViewController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let vc = pendingViewControllers.first as? HabitsViewController {
            title = title(date: vc.targetDate)
        }
    }
}

extension HabitsPageViewController: UIPageViewControllerDataSource {

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? HabitsViewController {
            return getViewContrller(byDate:viewController.targetDate.lastWeek())
        } else {
            return nil
        }
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? HabitsViewController {
            return getViewContrller(byDate:viewController.targetDate.nextWeek())
        } else {
            return nil
        }
    }
}
