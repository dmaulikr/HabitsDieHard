//
//  WeeklyHeaderView.swift
//  HabitsDieHard
//
//  Created by Taro Minowa on 8/23/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

import UIKit

class WeeklyHeaderView: UIView {
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    @IBOutlet weak var sundayLabel: UILabel!
    var labels: [UILabel] = []

    var targetDate: Date = Date() {
        didSet {
            let today = Date()
            if targetDate.getSunday() == today.getSunday() {
                // Highlight today
                // this should not be called from initializer
                if labels.isEmpty {
                    labels.append(sundayLabel)
                    labels.append(mondayLabel)
                    labels.append(tuesdayLabel)
                    labels.append(wednesdayLabel)
                    labels.append(thursdayLabel)
                    labels.append(fridayLabel)
                    labels.append(saturdayLabel)
                }
                let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
                let components = calendar.dateComponents([.weekday], from: today)
                labels[components.weekday! - 1].textColor = UIColor.orange
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
