//
//  DateExtension.swift
//  Outdoor360
//
//  Created by Apple on 07/01/2020.
//  Copyright © 2020 Touseef Sarwar. All rights reserved.
//

import Foundation

/// Date Extension
extension Date {
    /// Convert Date To String With Specific Format
    func toString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    /// Get Previous Dates from Date
    func previuosDays(NumberofDays: Int, format : String) -> [String]
    {
        var today = self
        var days : Array = [String]()
        days.append("\(today.toString(format))")
        for _ in 1...NumberofDays-1
        {
            let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: today)!
            days.append("\(previousDay.toString(format))")
            today = previousDay
        }
        return days
    }
    
    /// Get Previous Dates from Date
    func previuosYears(NumberofDays: Int, format : String) -> [String]
    {
        var today = self
        var years : Array = [String]()
        years.append("\(today.toString(format))")
        for _ in 1...NumberofDays-1
        {
            let previousYear = Calendar.current.date(byAdding: .year, value: -1, to: today)!
            years.append("\(previousYear.toString(format))")
            today = previousYear
        }
        return years
    }
}
