//
//  String.swift
//  Kid Circle
//
//  Created by Rohit Arora on 20/05/17.
//  Copyright © 2017 Rohit Arora. All rights reserved.
//

import Foundation
extension String {
    func isEmail() -> Bool {
        let regex = try? NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}", options: .caseInsensitive)
        return regex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.characters.count)) != nil
    }
    func isValidPassword() -> Bool {
        return self.characters.count >= APP_CONSTANT.MIN_PASSWORD_LENGTH && self.characters.count<=APP_CONSTANT.MAX_PASSWORD_LENGTH
    }
    
    func stringToDate(dateFormat:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: self)
    }
    
    func serverDateTimeToLocalDisplayable(format:String) -> String? {
        var startDateString =  self
        startDateString = (startDateString.components(separatedBy: ".")[0]) + " +0000"
        startDateString = startDateString.replacingOccurrences(of: "T", with: " ")
        let startDate = startDateString.stringToDate(dateFormat: DateFormats.utcFullDate)
        return startDate?.getYourLocalString(dateFormat: format)
    }
    
    func stringTo12HrFormat()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: self)
        
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date!)
    }
    
    
    func serverDateToLocalWithDateSuffix(_ appendYear:Bool = false)-> String {
        
        var startDateString =  self
        startDateString = (startDateString.components(separatedBy: ".")[0]) + " +0000"
        startDateString = startDateString.replacingOccurrences(of: "T", with: " ")
        let date = startDateString.stringToDate(dateFormat: DateFormats.utcFullDate) ?? Date()
        
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        
        // Formate
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = (appendYear) ? "MMM, yyyy" : "MMM"
        let newDate = dateFormate.string(from: date)
        
        var day  = "\(anchorComponents.day!)"
        switch (day) {
        case "1" , "21" , "31":
            day.append("st")
        case "2" , "22":
            day.append("nd")
        case "3" ,"23":
            day.append("rd")
        default:
            day.append("th")
        }
        return day + "\n" + newDate
    }
    
    func containsOnlyCharactersIn(_ matchCharacters: String) -> Bool {
        let disallowedCharacterSet = CharacterSet(charactersIn: matchCharacters).inverted
        return self.rangeOfCharacter(from: disallowedCharacterSet) == nil
    }
    func stripOutUnwantedCharactersFromText(characterSetString: String) -> String {
        let charSet = CharacterSet(charactersIn: characterSetString).inverted
        let cleanedString = self.components(separatedBy: charSet).joined(separator: "")
        return cleanedString
    }
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: from))
    }
    
    func convertDateFormat(fromFormat : String ,toFormat : String) -> (String) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        let date : Date = dateFormatter.date(from: self) ?? Date()
        dateFormatter.dateFormat = toFormat
        let stringFromDate = dateFormatter.string(from: date)
        return stringFromDate
    }
    
    func calculatePostedTime(format : String = "yyyy-MM-dd HH:mm:ss") -> String {
        let timeIntervalInSeconds : Int = getTimeIntervalSince(format : format)
        
        if timeIntervalInSeconds >= (24 * 7 * 60 * 60) {
            return self.convertDateFormat(fromFormat: format, toFormat: "MMM dd, yyyy")
        }
        else if (timeIntervalInSeconds / (60 * 60)) >= 1 && (timeIntervalInSeconds / (60 * 60)) < 24 {
            if timeIntervalInSeconds / (60 * 60) == 1 {
                return "\(timeIntervalInSeconds / (60 * 60)) hour ago"
            }
            else {
                return "\(timeIntervalInSeconds / (60 * 60)) hours ago"
            }
        }
        else if (timeIntervalInSeconds / (24 * 60 * 60)) >= 1 && (timeIntervalInSeconds / (24 * 60 * 60)) <= 7 {
            if timeIntervalInSeconds / (24 * 60 * 60) == 1 {
                return "\(timeIntervalInSeconds / (24 * 60 * 60)) day ago"
            }
            else {
                return "\(timeIntervalInSeconds / (24 * 60 * 60)) days ago"
            }
        }
        else if (timeIntervalInSeconds / 60) < 1 {
            if timeIntervalInSeconds == 1 {
                return "\(timeIntervalInSeconds) second ago"
            }
            else if timeIntervalInSeconds == 0 {
                return "Just Now"
            }
            else {
                return "\(timeIntervalInSeconds) seconds ago"
            }
        }
        else {
            if timeIntervalInSeconds / 60 == 1 {
                return "\(timeIntervalInSeconds / 60) minute ago"
            }
            else {
                return "\(timeIntervalInSeconds / 60) minutes ago"
            }
        }
    }
    func getTimeIntervalSince(format : String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateTime: Date? = dateFormatter.date(from: self)
        let sourceDate = Date()
        let sourceTimeZone = NSTimeZone(abbreviation: "GMT")
        let destinationTimeZone = NSTimeZone.system
        let sourceGMTOffset : Int = sourceTimeZone!.secondsFromGMT(for: sourceDate)
        let destinationGMTOffset: Int = destinationTimeZone.secondsFromGMT(for: sourceDate)
        let interval: TimeInterval = Double(destinationGMTOffset - sourceGMTOffset)
        let timeNow = Date(timeInterval: interval, since: sourceDate)
        let timePosted = Date(timeInterval: interval, since: dateTime ?? Date())
        return Int(timeNow.timeIntervalSince(timePosted))
    }
    var length: Int {
        return self.characters.count
    }
}

extension Dictionary {
    
    /// An immutable version of update. Returns a new dictionary containing self's values and the key/value passed in.
    func updatedValue(_ value: Value, forKey key: Key) -> Dictionary<Key, Value> {
        var result = self
        result[key] = value
        return result
    }
    
    var nullsRemoved: [Key: Value] {
        let tup = filter { !($0.1 is NSNull) }
        return tup.reduce([Key: Value]()) { $0.0.updatedValue($0.1.value, forKey: $0.1.key) }
    }
}

extension Int {
    func timeFormatConvertionTo12Hour() -> String{
        if self < 0 {
            return ""
            }
        var temp = "\(self)"
        if temp.characters.count < 4{
            temp = "0"+temp
        }
           let hour = String(temp.characters.prefix(2))
            let min = String(temp.characters.suffix(2))
            if(Int(hour)! > 12){
                temp = "0\(Int(hour)! - 12) : \(min) PM"
            }
            else{
                temp = "\(hour) : \(min) AM"
            }
            return temp
    }
}
