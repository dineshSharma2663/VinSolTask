//
//  Date.swift
//  Kid Circle
//
//  Created by Rohit Arora on 20/05/17.
//  Copyright © 2017 Rohit Arora. All rights reserved.
//

import Foundation

struct DateFormats {
    
    static let dateOnlyMonthName = "dd MMM, yyyy"
    static let dateOnly = "yyyy-MM-dd"
    static let dateOnlyServerStyle = "MM-dd-yyyy"
    static let timeOnly = "hh:mm a"
    static let fullTime = "HH:mm:ss"
    static let dateTimeBoth = ""
    static let utcFullDate = "yyyy-MM-dd HH:mm:ss +0000"
    static let TZFormatDate = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
}

extension Date {
    
    func getDayOfWeek()->Int? {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        myCalendar.timeZone = TimeZone(identifier: "UTC")!
        let myComponents = myCalendar.components(.weekday, from: self)
        let weekDay = myComponents.weekday
        return weekDay
    }
    
    func getYourLocalString(dateFormat:String)-> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
    func getYourUtcString(dateFormat:String)-> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
    func addDays(_ daysToAdd : Int) -> Date
    {
        let secondsInDays : TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded : Date = self.addingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    func roundUpWithInterval(_ interval: Int) -> Date {
        var time  = (Calendar.current as NSCalendar).components([NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.day, NSCalendar.Unit.month, NSCalendar.Unit.year], from: self)
        var minute = time.minute
        let minuteUnit = ceil(Float(minute!) / Float(interval))
        minute = Int(minuteUnit * Float(interval))
        time.minute = minute
        let newdate = Calendar.current.date(from: time)
        return newdate!
    }
}
