//
//  EmptyTablePlaceholder.swift
//  Kid Circle
//
//  Created by Rohit Arora on 20/05/17.
//  Copyright © 2017 Rohit Arora. All rights reserved.
//

import UIKit

class EmptyTablePlaceholder: UIView,NibLoadableView {

    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    @IBOutlet weak var contentbackView: UIView!
    @IBOutlet weak var noDataMessageLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    class func commonInit() -> EmptyTablePlaceholder {
        let nibView = Bundle.main.loadNibNamed(EmptyTablePlaceholder.nibName, owner: self, options: nil)?[0] as! EmptyTablePlaceholder
        nibView.layoutIfNeeded()
        return nibView
    }

}
