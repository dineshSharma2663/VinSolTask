//
//  MeetingListVC.swift
//  VinSolTask
//
//  Created by Dinesh Kumar on 10/01/18.
//  Copyright © 2018 Dinesh Kumar. All rights reserved.
//

import UIKit


enum  AnimationType{
    
    case fromLeft
    case fromRight
    case fromDown
    case none
    
}

class MeetingListVC: UIViewController,UIGestureRecognizerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var meetingListTableView : UITableView!
    
    var meetingListModel = MeetingListModel()
    var tableDataSource : CharPixelTableDataSource!
    var meetingsArray = [MeetingDetails]()
    var newMeetingButton : UIButton!
    var previousButton : ButtonWithTargetBlock!
    var nextButton : ButtonWithTargetBlock!
    var isApiGoingOn = false
    var currentDate : Date! // Local Date time
    
    //MARK: - VIEW APPEAR & LOAD FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        //UTC TO LOCAL DATE
        currentDate = Date().getYourLocalString(dateFormat: DateFormats.utcFullDate)!.stringToDate(dateFormat: DateFormats.utcFullDate)
        
        previousButton  = addLeftBarItemButton(buttonImage: #imageLiteral(resourceName: "leftArrow") , buttonTitle: " Prev") { [weak self] in
            let previousDate = CompanyInfoModel.sharedInstance.getPreviosuWorkingDay(localVisibileDate: self?.currentDate ?? Date())
            self?.getMeetingsForDate(yourDate: previousDate, buttonPressed: self?.previousButton, animation: .fromLeft)
        }
        
        nextButton = addRightBarItemButton(buttonImage: #imageLiteral(resourceName: "rightArrow") , buttonTitle: "Next ") {[weak self] in
            
            let nextDate = CompanyInfoModel.sharedInstance.getNextWorkingDayDate(localVisibileDate: self?.currentDate ?? Date())
        
            self?.getMeetingsForDate(yourDate: nextDate, buttonPressed: self?.nextButton, animation: .fromRight)
        }
        nextButton.semanticContentAttribute = .forceRightToLeft
        
        newMeetingButton = addRightBarItemButton( buttonTitle: "+") {
            self.performSegue(withIdentifier: SEGUES.NEW_MEETING_FROM_MEETING_LIST, sender: nil)
        }
        self.newMeetingButton.isHidden = !UIScreen.main.isLandScapeAndPhone()
        
        configMeetingListTableView()
        
        self.meetingListModel.fetchLastSavedData {[weak self] (response, date) in
            if let savedData = response,let oldDate = date {
                self?.currentDate = oldDate
                self?.meetingsArray = savedData
                self?.tableDataSource.showTableWithLeftRightDownAnimation(type: AnimationType.fromDown)
                self?.title = oldDate.getYourUtcString(dateFormat:"EEE dd/MM/yyyy")
                self?.getMeetingsForDate(yourDate: self?.currentDate ?? Date(), buttonPressed: nil, animation:.none)
                
            }else{
                self?.getMeetingsForDate(yourDate: self?.currentDate ?? Date(), buttonPressed: nil, animation:.fromDown)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nextButton.semanticContentAttribute = .forceRightToLeft
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nextButton.semanticContentAttribute = .forceRightToLeft
        getMeetingsForDate(yourDate: currentDate, buttonPressed: nil, animation:.none)
    }
    
    //MARK: - VIEW TRANSITION ORIENTATION CHANGE FUNCTION CALLED
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.newMeetingButton.isHidden = !UIScreen.main.isLandScapeAndPhone()
            
        }, completion: { _ in
        })
    }
    
    //MARK: - CONFIGURE MEETING LIST TABLE
    func configMeetingListTableView() {
        tableDataSource = CharPixelTableDataSource(estimatedHeight: 100, tableView: meetingListTableView, numberOfRows: {[weak self] (section) -> (Int) in
            return self?.meetingsArray.count ?? 0
            }, heightForRow: { (indexPath) -> (CGFloat) in
                return UITableViewAutomaticDimension
        }, configureCellBlock: { [weak self](indexPath) -> (UITableViewCell) in
            let meetingCell = self?.meetingListTableView.dequeueReusableCell(withIdentifier: MeetingDetailsTableCell.reuseIdentifier) as! MeetingDetailsTableCell
            meetingCell.configCell(cellDetail: self?.meetingsArray[indexPath.row])
            return meetingCell
            }, aRowSelectedListener: { (indexPath) in
        })
        
        tableDataSource.addEmptyPlaceholder()
        
        tableDataSource.addRefreshControl { [weak self] in
            self?.getMeetingsForDate(yourDate: self?.currentDate ?? Date(), buttonPressed: nil, animation:.none)
        }
        tableDataSource.placeHolder.noDataMessageLabel.text = "No meeting scheduled for this date."
        
        meetingListTableView.tableFooterView = UIView(frame: .zero)
        meetingListTableView.separatorStyle = .singleLine
        meetingListTableView.delegate = tableDataSource
        meetingListTableView.dataSource = tableDataSource
    }
    
    //MARK: - GETTING MEETINGS FOR GIVEN DATE & & ANIMATION
    func getMeetingsForDate(yourDate:Date, buttonPressed:ButtonWithTargetBlock?,animation:AnimationType) {
        if !(isApiGoingOn){
            
            isApiGoingOn = true
            buttonPressed?.showLoading()
            if (self.tableDataSource.tableView?.numberOfRows(inSection: 0) ?? 0) > 0{
                self.tableDataSource.tableView?.scrollToRow(at: IndexPath(row:0,section:0), at: .top, animated: true)
            }
            meetingListModel.getAllMeetingsForDate(yourDate: yourDate, completionHandler: {[weak self] (meetings,isSuccess) in
                self?.isApiGoingOn = false
                if isSuccess{
                    self?.meetingsArray = meetings
                    self?.tableDataSource.showTableWithLeftRightDownAnimation(type: animation)
                    self?.currentDate = yourDate
                    self?.title = yourDate.getYourUtcString(dateFormat:"EEE dd/MM/yyyy")
                }
                self?.tableDataSource.refreshControl?.endRefreshing()
                buttonPressed?.hideLoading()
            })
        }
    }
    
    //MARK: - SUBMIT ACTION
    @IBAction func scheduleMeetingButtonAction(_ sender : UIButton){
        
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
