//
//  Date+Helper.swift
//  HealthTabs
//
//  Created by bnulo on 3/3/23.
//

import Foundation

extension Date {

    static var currentYear: Int? {

        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        let year = components.year
        return year
    }

    func changeTimeTo(hour: Int, minute: Int, second: Int) -> Date {

        var components = Calendar.current.dateComponents([.hour, .minute, .second], from: self)
        components.hour = hour
        components.minute = minute
        components.second = second

        let date = Calendar.current.date(from: components) ?? self
        return date
    }

    static func getDateOf7DaysAgoAt0AM() -> Date {
        let day = Calendar.current.date(byAdding: .day,
                                        value: -7,
                                        to: Date()) ?? Date()
        let date = day.changeTimeTo(hour: 0, minute: 0, second: 0)
        return date
    }

    static func getDateOfFirstDayOf(year: Int) -> Date? {

        var components = DateComponents()
        components.year = year
        components.month = 1
        components.day = 1
        components.hour = 0
        components.minute = 0
        let date = Calendar.current.date(from: components)
        return date
    }

    static func getDateOfFirstDayOfSomeYearsAgo(numberOfYears: Int) -> Date? {
        if let currentYear {
            let year = currentYear - numberOfYears
            return getDateOfFirstDayOf(year: year)
        }
        return nil
    }

    static func firstDayOfWeek() -> Date {
        return Calendar(identifier: .iso8601)
            .date(from: Calendar(identifier: .iso8601)
                .dateComponents([.yearForWeekOfYear, .weekOfYear],
                                from: Date())) ?? Date()
    }
}
