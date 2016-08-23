//
//  NSDateExtensions.swift
//  HabitsDieHard
//
//  Created by Taro Minowa on 8/22/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

import Foundation

// From http://stackoverflow.com/questions/24089999/how-do-you-create-a-swift-date-object
extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}