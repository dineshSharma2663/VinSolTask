//
//  APP_CONFIG.swift
//  Zing
//
//  Created by dinesh sharma on 30/05/17.
//  Copyright © 2017 dinesh sharma. All rights reserved.
//

import UIKit
import CoreLocation

struct APP_CONSTANT {
    
    static let DEVICE_TYPE                                          = "ios"
    static let APP_VERSION                                          = "100"
    static let DISMISS_REFRESH_TIME_INTERVAL                        = 0.5
    static let STATUS_BAR_MESSAGE_DISMISS_TIME                      = 3.0
    static let MIN_PASSWORD_LENGTH                                  = 6
    static let MAX_PASSWORD_LENGTH                                  = 20
    
    //URLS
    static let APP_STORE_URL                                        = "https://www.google.co.in/"
    
    //KEYS
    static let GOOGLE_API_KEY                                       = "AIzaSyCocWi9l0wncqIWR_y1RbVXxjpASeAfAQk"

    //APP FONTS
    static let themeFontNormal = "Avenir-Medium"
    static let themeFontLight = "Avenir-Light"
    static let themeFontBold = "Avenir-Bold"
    
    //GOOGLE MAPS
    static let GOOGLE_MAP_LAUNCH_ZOOM                               = 15.5
    static let GOOGLE_MAP_LAUNCH_TILE_ANGLE                         = 60.0
    static let DEFAULT_APP_LOCATION                                 = CLLocationCoordinate2D(latitude: 40.679368, longitude: -100.251267)
    
    static let NO_INTERNET_MESSAGE = "No Internet connection found. Check your connection or try again."
}



