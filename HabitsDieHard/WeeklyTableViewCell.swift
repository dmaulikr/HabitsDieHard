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


    override func awakeFromNib() {
        super.awakeFromNib()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WeeklyTableViewCell.dayTapped))
        mondayView.addGestureRecognizer(gestureRecognizer)
    }

    func dayTapped(gestureRecognizer: UIGestureRecognizer) {
        NSLog("tapped")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
