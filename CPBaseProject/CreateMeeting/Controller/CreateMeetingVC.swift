//
//  CreateMeetingVC.swift
//  VinSolTask
//
//  Created by Dinesh Kumar on 10/01/18.
//  Copyright © 2018 Dinesh Kumar. All rights reserved.
//

import UIKit

class CreateMeetingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let _ = addLeftBarItemButton(buttonImage: #imageLiteral(resourceName: "leftArrow") ,buttonTitle: " Back") {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - SUBMIT ACTION
    @IBAction func submitButtonAction(_ sender : UIButton){
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
