//
//  HabitsPageViewController.swift
//  HabitsDieHard
//
//  Created by Taro Minowa on 9/18/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

import Foundation
import UIKit

class HabitsPageViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers([HabitsViewController(Date())], direction: .forward, animated: true, completion: nil)
        dataSource = self
    }
}

extension HabitsPageViewController: UIPageViewControllerDataSource {

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? HabitsViewController {
            let targetDate = viewController.targetDate.lastWeek()
            return HabitsViewController(targetDate)
        } else {
            return nil
        }
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? HabitsViewController {
            let targetDate = viewController.targetDate.nextWeek()
            return HabitsViewController(targetDate)
        } else {
            return nil
        }
    }
}
