//
//  MeetingDataModel.swift
//  CPBaseProject
//
//  Created by Dinesh Kumar on 11/01/18.
//  Copyright © 2018 dinesh sharma. All rights reserved.
//

import Foundation

class MeetingDetails : NSObject,NSCoding {
    
    var descriptn : String?
    var attendee : String?
    var timing :String?
    var startTime: String?
    var endTime :String?
    
    required init?(coder aDecoder: NSCoder) {
        endTime = aDecoder.decodeObject(forKey: "endTime") as? String ?? ""
        startTime = aDecoder.decodeObject(forKey: "startTime") as? String ?? ""
        attendee = aDecoder.decodeObject(forKey: "attendee") as? String ?? ""
        descriptn = aDecoder.decodeObject(forKey: "descriptn") as? String ?? ""
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(endTime, forKey: "endTime")
        aCoder.encode(startTime, forKey: "startTime")
        aCoder.encode(attendee, forKey: "attendee")
        aCoder.encode(descriptn, forKey: "descriptn")
        
    }
    
    init(json:[String:AnyObject]){
        
        startTime = (json["start_time"] as? String ?? "").stringTo12HrFormat()
        endTime = (json["end_time"] as? String ?? "").stringTo12HrFormat()
        
        
        descriptn = json["description"] as? String ?? ""
        attendee = (json["participants"] as? [String] ?? []).joined(separator: ", ")
    }
}
