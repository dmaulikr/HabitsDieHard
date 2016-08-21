//
//  WeeklyTableViewCell.swift
//  HabitsDieHard
//
//  Created by Taro Minowa on 8/20/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

import UIKit

class WeeklyTableViewCell: UITableViewCell {
    @IBOutlet weak var mondayView: UIView!
    @IBOutlet weak var tuesdayView: UIView!
    @IBOutlet weak var wednesdayView: UIView!
    @IBOutlet weak var thursdayView: UIView!
    @IBOutlet weak var fridayView: UIView!
    @IBOutlet weak var saturdayView: UIView!
    @IBOutlet weak var sundayView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        let selector = #selector(WeeklyTableViewCell.dayTapped)
        mondayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
        tuesdayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
        wednesdayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
        thursdayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
        fridayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
        saturdayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
        sundayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
    }

    func dayTapped(gestureRecognizer: UIGestureRecognizer) {
        NSLog("tapped")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
