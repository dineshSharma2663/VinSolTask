//
//  AppServerAPIs.swift
//  Zing
//
//  Created by dinesh sharma on 30/05/17.
//  Copyright © 2017 dinesh sharma. All rights reserved.
//

import Foundation
//http://13.58.40.198/documentation#!/eatouts/apieatouts_get_0
let DEV_URL = "http://13.58.40.198:80/v1/"
let BASE_URL = DEV_URL

struct NETWORK_APIS {
    static let URL_FLAG_LOCATIONS = BASE_URL + "flagLocations"
    static let URL_USER_INFO =  BASE_URL + "users/"
    static let URL_EMAIL_SIGNUP = BASE_URL + "auth/email/registration"
    static let URL_EMAIL_LOGIN = BASE_URL + "auth/email/login"
    static let URL_SOCIAL_FACEBOOK = BASE_URL + "appAuth/facebook"
    static let URL_SOCIAL_GOOGLE = BASE_URL + "appAuth/google"
    static let URL_LOGOUT = BASE_URL + "users/logout"
    static let URL_EATOUTS = BASE_URL + "eatouts"
    static let URL_GET_RESET_PASSWORD_TOKEN = BASE_URL + "users/getResetPasswordToken"
    static let URL_CHANGE_PASSWORD = BASE_URL + "users/changePassword"
    static let URL_RESET_PASSWORD = BASE_URL + "users/resetPassword"
    static let URL_GET_USER = BASE_URL + "users"
    static let URL_RESEND_OTP = BASE_URL + "users/resendOTP"
    static let URL_VERIFY_OTP = BASE_URL + "users/verifyOTP"
}
