//
//  Date+Today.swift
//  Today
//
//  Created by Rood-Landy Thezard on 6/8/22.
//

import Foundation

extension Date{
    //Computed property that returns a formatted and localized string representation of the date and time
    var dayAndTimeText: String {
        //Creates string representation of the time and assigns it to a constant named timeText
        let timeText = formatted(date: .omitted, time: .shortened)
        
        //If the Meeting is timed for the current calendar day then the Meeting's time will be display as "Today at 3:00 PM" for example else it just uses the calendar date.
        if Locale.current.calendar.isDateInToday(self) {
            //Creates a time formatted string using NSLocalizedString which is used with timeText to create our day and time string that is returned.
            let timeFormat = NSLocalizedString("Today at %@", comment: "Today at time format string")
            return String(format: timeFormat, timeText)
        } else {
            //Creates string representation of the date and format for date and time that is used to create our day and time string that is returned.
            let dateText = formatted(.dateTime.month(.abbreviated).day())
            let dateAndTimeFormat = NSLocalizedString("%@ at %@", comment: "Date and time format string")
            return String(format: dateAndTimeFormat, dateText, timeText)
        }
    }
    
    //Computed property named dayText that returns a formatted and localized string representation of only the date.
    var dayText: String {
        //If the Meeting is timed for the current calendar date then the Meeting's day is displayed as "Today" else it just uses the calendar date.
        if Locale.current.calendar.isDateInToday(self) {
            return NSLocalizedString("Today", comment: "Today due date description")
        }else {
            return formatted(.dateTime.month().day().weekday(.wide))
        }
    }
}
