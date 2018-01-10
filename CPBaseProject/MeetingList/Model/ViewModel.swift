//
//  ViewModel.swift
//  CPBaseProject
//
//  Created by Dinesh Kumar on 11/01/18.
//  Copyright © 2018 dinesh sharma. All rights reserved.
//

import Foundation

class MeetingListModel : NSObject {
    
    var count = 0
    
    func saveMeetingData(meetings:[MeetingDetails],savedForDate:Date){
        let savedData = [
            "savedFor":savedForDate,
            "data" :meetings
            ] as [String:Any]
        
        let savingData = NSKeyedArchiver.archivedData(withRootObject: savedData)
        UserDefaults.standard.setValue(savingData, forKey:USER_DEFAULTS.saveMeetings)
    }
    
    func fetchLastSavedData(completionHandler:@escaping(_ response : [MeetingDetails]?,_ savedFor:Date?) -> Void) {
        if let data = UserDefaults.standard.object(forKey: USER_DEFAULTS.saveMeetings) as? Data {
            let unarc = NSKeyedUnarchiver(forReadingWith: data)
            if let savedData = unarc.decodeObject(forKey: "root") as? [String:Any],let savedFor = savedData["savedFor"] as? Date,let meetings = savedData["data"] as? [MeetingDetails] {
                completionHandler(meetings,savedFor)
            }else{
                completionHandler(nil,nil)
            }
        }else{
            completionHandler(nil,nil)
        }
    }
    
    func getAllMeetingsForDate(yourDate:Date,completionHandler:@escaping(_ response : [MeetingDetails], _ isSuccess:Bool) -> Void){
        
        let requestUrl = "http://fathomless-shelf-5846.herokuapp.com/api/schedule?date=" + (yourDate.getYourUtcString(dateFormat: "dd/MM/yyyy") ?? "")
        
        print(requestUrl)
        APIClient.sharedClient.callAPIMethod(requestUrl, parameters: nil, method: .GET, isHeaderRequired: false, showErrorMessage: true, isUploadingMedia: false) {[weak self] (response, isSuccess, error) in
            print(response)
            var meetingsArray = [MeetingDetails]()
            if isSuccess{
                if let meetings = response?["data"] as? [[String:AnyObject]]{
                    for detail in meetings{
                        let temp = MeetingDetails(json:detail)
                        meetingsArray.append(temp)
                    }
                    self?.saveMeetingData(meetings: meetingsArray, savedForDate: yourDate)
                }
            }
            completionHandler(meetingsArray,isSuccess)
        }
    }
}
