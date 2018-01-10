//
//  AppNavigation.swift
//  Zing
//
//  Created by dinesh sharma on 01/06/17.
//  Copyright © 2017 dinesh sharma. All rights reserved.
//

import UIKit

class AppNavigation: UINavigationController {

    override func viewDidLoad() {
        self.navigationBar.barTintColor = UIColor.themeColor
        self.navigationBar.barStyle = .black
        //self.navigationBar.tintColor = UIColor.white
        self.navigationBar.isTranslucent = true
        let navigationTitleFont = UIFont(name: "Avenir-Medium", size: 18)!
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName : navigationTitleFont]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

