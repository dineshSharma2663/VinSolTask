//
//  CommonEnums.swift
//  Kid Circle
//
//  Created by Rohit Arora on 20/05/17.
//  Copyright © 2017 Rohit Arora. All rights reserved.
//

import Foundation


struct SEGUES {
    
    static let NEW_MEETING_FROM_MEETING_LIST = "NEW_MEETING_FROM_MEETING_LIST"
}

enum ScreenOpenTo {
    case normalLogin
    case editProfile
    case verifyAfterHome
    case createChildProfile
    case editChildProfile
    case showAllCategories
    case showAllActivitiesOfCategory
}
 
struct USER_DEFAULTS {
    static let saveMeetings = "saveMeetingsForLastFetchDate"
    static let AccessToken = "AccessToken"
}



struct CORE_DATA_ENTITY {
    static let userAccountInfo = "UserAccountInfo"
}

struct STORYBOARDS {
    static let afterLogin = "AfterLogin"
    static let beforeLogin = "BeforeLogin"
}
