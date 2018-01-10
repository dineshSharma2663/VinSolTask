//
//  ListTableCell.swift
//  CPBaseProject
//
//  Created by Dinesh Kumar on 11/01/18.
//  Copyright © 2018 dinesh sharma. All rights reserved.
//

import UIKit

class MeetingDetailsTableCell : UITableViewCell,ReusableView{
    
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var attendeeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        self.selectionStyle = .none
    }
    
    func configCell(cellDetail:MeetingDetails?){
        timingLabel.text = (cellDetail?.startTime ?? "") + " - " + (cellDetail?.endTime ?? "")
        attendeeLabel.addAttributedString(firstString: "Attendee: - ", secondString: (cellDetail?.attendee ?? ""), firstColor: UIColor.darkGray, secondColor: UIColor(red: 54/255, green: 54/255, blue: 54/255, alpha: 0.65), firstFont: UIFont(name:"Avenir-Medium",size:15.0)!, secondFont: UIFont(name:"Avenir-Book",size:14.5)!,lineSpacing: 3,alignMent: .left)
        descriptionLabel.text = cellDetail?.descriptn ?? ""
    }
}
