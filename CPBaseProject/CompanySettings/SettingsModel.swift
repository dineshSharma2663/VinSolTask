//
//  SettingsModel.swift
//  CPBaseProject
//
//  Created by Dinesh Kumar on 11/01/18.
//  Copyright © 2018 dinesh sharma. All rights reserved.
//

import Foundation

class CompanyInfoModel : NSObject {
    
    static let sharedInstance = CompanyInfoModel()
    var workingDays = [1,2,3,4,5,6,7]
    
    func getNextWorkingDayDate(localVisibileDate:Date)->Date{
        
        let weekDay = localVisibileDate.getDayOfWeek()!
        var incrementNumber = 0
        if  weekDay == workingDays.last!{
            incrementNumber = 7 - weekDay + workingDays.first!
        }else{
            let index = workingDays.index(of: weekDay)
            let nextWorkingDayNumber = workingDays[index!+1]
            incrementNumber = nextWorkingDayNumber - weekDay
        }
        
        let nextDate = localVisibileDate.addDays(incrementNumber)
        return nextDate
    }
    
    func getPreviosuWorkingDay(localVisibileDate:Date)->Date{
        
        let weekDay = localVisibileDate.getDayOfWeek()!
        var decrementNumber = 0
        if weekDay == workingDays.first! {
            decrementNumber = workingDays.last! - weekDay - 7
        }else{
            let index = workingDays.index(of: weekDay)
            let nextWorkingDayNumber = workingDays[index!-1]
            decrementNumber = nextWorkingDayNumber - weekDay
        }
        
        let nextDate = localVisibileDate.addDays(decrementNumber)
        return nextDate
    }
}
