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

    fileprivate var dateToVC: [String: HabitsViewController] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers([getViewContrller(byDate: Date())], direction: .forward, animated: true, completion: nil)
        dataSource = self
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
