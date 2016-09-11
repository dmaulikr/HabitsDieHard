//
//  NSDateExtensions.swift
//  HabitsDieHard
//
//  Created by Taro Minowa on 8/22/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

import Foundation

extension NSDate
{
    // From http://stackoverflow.com/questions/24089999/how-do-you-create-a-swift-date-object
    convenience init(dateString: String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }

    // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/DatesAndTimes/Articles/dtCalendricalCalculations.html#//apple_ref/doc/uid/TP40007836-SW12
    public func getSunday() -> NSDate {
        let gregorianCalendar = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)

        // Get the weekday component of the current date
        let weekdayComponents = gregorianCalendar!.components(NSCalendarUnit.Weekday, fromDate:self)

        /*
         Create a date components to represent the number of days to subtract from the current date.
         The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today is Sunday, subtract 0 days.)
         */
        let componentsToSubtract = NSDateComponents()
        componentsToSubtract.day = 0 - (weekdayComponents.weekday - 1);

        let beginningOfWeek = gregorianCalendar!.dateByAddingComponents(componentsToSubtract, toDate:self, options:NSCalendarOptions(rawValue: 0))

        /*
         Optional step:
         beginningOfWeek now has the same hour, minute, and second as the original date (today).
         To normalize to midnight, extract the year, month, and day components and create a new date from those components.
         */
        let components = gregorianCalendar!.components([.Year, .Month, .Day], fromDate: beginningOfWeek!)
        return gregorianCalendar!.dateFromComponents(components)!
    }

    public func getWholeWeekDates() -> [NSDate] {
        let sunday = getSunday()
        var weekArray = [sunday]
        let gregorianCalendar = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)
        for i in 1...6 {
            let componentToAdd = NSDateComponents()
            componentToAdd.day = i
            let date = gregorianCalendar!.dateByAddingComponents(componentToAdd, toDate: sunday, options: NSCalendarOptions(rawValue: 0))
            weekArray.append(date!)
        }
        return weekArray
    }

    public func simpleDateKey() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.stringFromDate(self)
    }

    public func dateByAdding(delta: Int) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        return calendar.dateByAddingUnit(
            .Day,
            value: delta,
            toDate: self,
            options: []
        )!
    }
}
