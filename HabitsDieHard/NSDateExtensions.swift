//
//  DateExtensions.swift
//  HabitsDieHard
//
//  Created by Taro Minowa on 8/22/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

import Foundation

extension Date
{
    // From http://stackoverflow.com/questions/24089999/how-do-you-create-a-swift-date-object
    init(dateString: String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = Locale(identifier: "en_US_POSIX")
        let d = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:d)
    }

    // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/DatesAndTimes/Articles/dtCalendricalCalculations.html#//apple_ref/doc/uid/TP40007836-SW12
    public func getSunday() -> Date {
        let gregorianCalendar = Calendar(identifier: Calendar.Identifier.gregorian)

        // Get the weekday component of the current date
        let weekdayComponents = gregorianCalendar.dateComponents([.weekday], from:self)

        /*
         Create a date components to represent the number of days to subtract from the current date.
         The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today is Sunday, subtract 0 days.)
         */
        var componentsToSubtract = DateComponents()
        componentsToSubtract.day = 0 - (weekdayComponents.weekday! - 1);

        let beginningOfWeek = gregorianCalendar.date(byAdding: componentsToSubtract, to:self);

        /*
         Optional step:
         beginningOfWeek now has the same hour, minute, and second as the original date (today).
         To normalize to midnight, extract the year, month, and day components and create a new date from those components.
         */
        let components = gregorianCalendar.dateComponents([.year, .month, .day], from: beginningOfWeek!)
        return gregorianCalendar.date(from: components)!
    }

    public func getWholeWeekDates() -> [Date] {
        let sunday = getSunday()
        var weekArray = [sunday]
        let gregorianCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        for i in 1...6 {
            var componentToAdd = DateComponents()
            componentToAdd.day = i
            let date = gregorianCalendar.date(byAdding: componentToAdd, to: sunday)
            weekArray.append(date!)
        }
        return weekArray
    }

    public func simpleDateKey() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: self)
    }

    public func dateByAdding(delta: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: delta, to: self)!
    }

    public func nextWeek() -> Date {
        return dateByAdding(delta: 7)
    }
    public func lastWeek() -> Date {
        return dateByAdding(delta: -7)
    }


}
