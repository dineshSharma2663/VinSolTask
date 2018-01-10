//
//  CharPixelResource.swift
//  Kid Circle
//
//  Created by Rohit Arora on 20/05/17.
//  Copyright © 2017 dinesh sharma. All rights reserved.
//

import Foundation
import UIKit
import Photos
import MobileCoreServices

enum StatusBarStyle {
    case error
    case success
}

protocol StatusBarNotificationProtocol {
    func dismissStatusBarView()
    //func showHideStatusBar(message:String,dismissAfter:TimeInterval?,style: StatusBarStyle)
}

protocol ReusableView {
    
}

extension ReusableView where Self: UIView {
    
    static var reuseIdentifier :String {
        return String(describing: self)
    }
}

protocol NibLoadableView : class{
}

extension NibLoadableView where Self: UIView {
    static var nibName :String {
        return String(describing: self)
    }
}

protocol StoryboardView {
}

extension StoryboardView where Self: UIViewController {
    
    static var storyboardId :String {
        return String(describing: self)
    }
}


class StatusBarErrorMessage :NSObject {
    
    var reachability:Reachability?
    
    static let sharedInstance = StatusBarErrorMessage()
    
    func orientationChanged() {
        
        DispatchQueue.main.async {
            self.statusBarLabel?.frame = CGRect(x:  self.statusBarLabel?.frame.origin.x ?? 0, y:  self.statusBarLabel?.frame.origin.y ?? -20, width: UIScreen.main.bounds.width, height: 20)
        }
    }

    
    func addNetWorkNotifier() {
        if reachability == nil {
            reachability = Reachability.init()
            try? reachability?.startNotifier()
            NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name:ReachabilityChangedNotification, object: nil)
            reachabilityChanged()
            NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

        }
        // For first time app launch, we have checked internet status
    }
    
    func reachabilityChanged() {
        if !(reachability?.isReachable)!{
            print("disconnected")
            showHideStatusBar(message: "You are offline", dismissAfter: nil, style: .error)
        }else {
            print("connected")
            showHideStatusBar(message: "You are online", dismissAfter: APP_CONSTANT.STATUS_BAR_MESSAGE_DISMISS_TIME, style: .success)
        }
    }
    
    
    
    var statusBarLabel : UILabel?
    
    func dismissStatusBarView() {
        
        UIView.animate(withDuration: 0.5, animations: { 
            self.statusBarLabel?.transform = CGAffineTransform.identity

        }) { (finished) in
             self.statusBarLabel?.isHidden = true
        }

    }
    
    func showHideStatusBar(message:String,dismissAfter:TimeInterval?,style: StatusBarStyle) {
        
        if statusBarLabel == nil {
            statusBarLabel = UILabel()
            statusBarLabel?.frame = CGRect(x: 0, y: -20, width: UIScreen.main.bounds.width, height: 20)
            statusBarLabel?.font = UIFont(name: "Avenir-Book", size: 13.5)
            statusBarLabel?.textAlignment = .center
            statusBarLabel?.textColor = UIColor.white
            if let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? UIWindow {
                statusBarWindow.addSubview(statusBarLabel!)
            }
        }
        statusBarLabel?.isHidden = false
        statusBarLabel?.text = message
        statusBarLabel?.frame = CGRect(x: statusBarLabel?.frame.origin.x ?? 0, y: statusBarLabel?.frame.origin.y ?? -20, width: UIScreen.main.bounds.width, height: 20)

        
        UIView.animate(withDuration: 0.5) {
            self.statusBarLabel?.transform = CGAffineTransform(translationX: 0, y: 20)
        }
        
        switch style {
        case StatusBarStyle.error:
            statusBarLabel?.backgroundColor = UIColor.errorColor
        default:
            statusBarLabel?.backgroundColor = UIColor.successColor
        }
        
        if dismissAfter != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + dismissAfter!, execute: {
                if !((self.reachability?.isReachable) ?? true){
                    print("disconnected")
                    self.showHideStatusBar(message: "You are offline", dismissAfter: nil, style: .error)
                }else{
                    self.dismissStatusBarView()
                }
            })
        }
    }
}


//MARK: - CUSTOM COLLECTION SOURCE
typealias CollectionCellConfigBlock = ( _ indexpath: IndexPath) -> (UICollectionViewCell)
typealias SizeForItem = ( _ indexpath: IndexPath) -> (CGSize)
typealias  DidSelectedCollectionCell = (_ indexPath : IndexPath) -> ()
typealias  WillDisplayCollectionCell = (_ indexPath : IndexPath) -> ()
typealias  NumberOfItems = ( _ section: Int) -> (Int)
typealias  NumberOfSections = () -> (Int)
typealias  LineSpacing = ( _ section: Int) -> (CGFloat)
typealias  InterimSpacing = ( _ section: Int) -> (CGFloat)
typealias  SectionHeader = ( _ section: Int) -> (CGSize)
typealias  SectionFooter = ( _ section: Int) -> (CGSize)
class CharPixelCollectionDataSource : NSObject {
    
    var collectionView  : UICollectionView?
    var configureCellBlock : CollectionCellConfigBlock?
    var cellSelect : DidSelectedCollectionCell?
    var willDisplay : WillDisplayCollectionCell?
    var itemsCount : NumberOfItems?
    var sizeForItem : SizeForItem?
    var mininumLineSpacing : LineSpacing?
    var minimumInterimSpacing : InterimSpacing?
    var placeHolder : EmptyTablePlaceholder?
    var refreshControl : UIRefreshControl!
    var sectionCount : NumberOfSections?
    var sizeForSectionHeader : SectionHeader?
    var sizeForSectionFooter : SectionFooter?
    
    
    init(collection : UICollectionView?,numberOfSections:NumberOfSections? = {(1)},sizeForHeader : SectionHeader? = { section in (.zero)},sizeForFooter : SectionFooter? = { section in (.zero)}, lineSpacing:LineSpacing? = { section in (10)},interimSpacing:InterimSpacing? = { section in (10)},numberOfItems:NumberOfItems?,sizeForCell : SizeForItem?, configureCellBlock : CollectionCellConfigBlock? , aRowSelectedListener : @escaping DidSelectedCollectionCell, willDisplayCellListener : @escaping WillDisplayCollectionCell) {
        super.init()
        
        sizeForSectionHeader = sizeForHeader
        sizeForSectionFooter = sizeForFooter
        willDisplay = willDisplayCellListener
        sectionCount = numberOfSections
        mininumLineSpacing = lineSpacing
        minimumInterimSpacing = interimSpacing
        self.collectionView = collection
        self.itemsCount = numberOfItems
        sizeForItem = sizeForCell
        self.configureCellBlock = configureCellBlock
        cellSelect = aRowSelectedListener
        self.addEmptyPlaceholder()
    }
    
    func addEmptyPlaceholder() {
        placeHolder = EmptyTablePlaceholder.commonInit()
        collectionView?.backgroundView = placeHolder
    }
    
    override init () {
        super.init()
    }
    
    var refreshCollection : AddRefresControl?
    
    func addRefreshControl(refreshAdded:AddRefresControl? = nil){
        if refreshAdded != nil {
            refreshControl = UIRefreshControl()
            refreshCollection = refreshAdded
            refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            refreshControl.addTarget(self, action:  #selector(refresh), for: .valueChanged)
            collectionView?.addSubview(refreshControl) //
        }
    }
    func endRefreshControl() {
        refreshControl.endRefreshing()
    }
    
    func refresh() {
        // Code to refresh table view
        if let block = self.refreshCollection{
            block()
        }
    }
}
extension CharPixelCollectionDataSource : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func reloadCollectionView(){
        placeHolder?.activityLoader.stopAnimating()
        self.collectionView?.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + APP_CONSTANT.DISMISS_REFRESH_TIME_INTERVAL, execute: {
            self.refreshControl?.endRefreshing()
        })
    }
    
    func showHideCollection(hide:Bool){
        self.collectionView?.isHidden = hide
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let block = self.configureCellBlock{
            return block(indexPath)
        }
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let block = self.cellSelect{
            block(indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let block = self.willDisplay{
            block(indexPath)
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionCount?() ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItem?(indexPath) ??  CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 25
        let items = itemsCount?(section) ?? 0
        placeHolder?.contentbackView?.isHidden = (items == 0 && !(placeHolder?.activityLoader.isAnimating ?? true) && section == 0) ? false : true
        return items
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInterimSpacing?(section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return sizeForSectionHeader?(section) ?? CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return sizeForSectionFooter?(section) ?? CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return mininumLineSpacing?(section) ?? 0
    }
}

//MARK: - CUSTOM TABLE SOURCE
typealias  NumberOfRows = ( _ section: Int) -> (Int)
typealias  TableCellConfigureBlock = ( _ indexpath: IndexPath) -> (UITableViewCell)
typealias  DidSelectedTableCell = (_ indexPath : IndexPath) -> ()
typealias  ViewForHeaderInSection = (_ section : Int) -> UIView?
typealias  HeightForRow = (_ indexpath: IndexPath) -> (CGFloat)
typealias AddRefresControl = () -> ()
typealias  HeightOfSections = (_ section : Int) -> (CGFloat)

class CharPixelTableDataSource : NSObject {
    
    var tableView  : UITableView?
    var tableViewEstimatedRowHeight : CGFloat?
    var configureCellBlock : TableCellConfigureBlock?
    var cellSelect : DidSelectedTableCell?
    var returnRows : NumberOfRows?
    var getHeight : HeightForRow?
    var headerViewBlock : ViewForHeaderInSection?
    var headerViewHeight : CGFloat = 0
    var mininumLineSpacing : CGFloat!
    var minimumInterimSpacing : CGFloat!
    var refreshControl : UIRefreshControl?
    var refreshTable : AddRefresControl?
    var placeHolder : EmptyTablePlaceholder!
    var sectionsCount : NumberOfSections!
    var sectionHeight : HeightOfSections!
    //  init(estimatedHeight :CGFloat, tableView : UITableView? ,headerView: ViewForHeaderInSection? ,numberOfRows:NumberOfRows?,heightForRow : HeightForRow?, configureCellBlock : TableCellConfigureBlock? , aRowSelectedListener : @escaping DidSelectedTableCell)
    init(estimatedHeight :CGFloat, tableView : UITableView? ,headerView: ViewForHeaderInSection? = {(section) in return nil},numberOfSections:NumberOfSections? = ({1}) , heightOfSections:HeightOfSections? = {(section) in return 0.0}, numberOfRows:NumberOfRows?,heightForRow : HeightForRow?, configureCellBlock : TableCellConfigureBlock? , aRowSelectedListener : @escaping DidSelectedTableCell){
        
        super.init()
        sectionsCount = numberOfSections
        sectionHeight = heightOfSections
        headerViewBlock = headerView
        self.getHeight =  heightForRow
        self.tableView = tableView
        self.returnRows = numberOfRows
        self.tableViewEstimatedRowHeight = estimatedHeight
        self.configureCellBlock = configureCellBlock
        cellSelect = aRowSelectedListener
        self.addEmptyPlaceholder()

    }
    
    func addRefreshControl(refreshAdded:AddRefresControl? = nil){
        if refreshAdded != nil {
            if refreshControl != nil {
                refreshControl?.removeFromSuperview()
                refreshControl = nil
            }
            refreshControl = UIRefreshControl()
            refreshTable = refreshAdded
            refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
            refreshControl?.addTarget(self, action:  #selector(refresh), for: .valueChanged)
            tableView?.addSubview(refreshControl!) 
        }
    }
    
    func addEmptyPlaceholder() {
         placeHolder = EmptyTablePlaceholder.commonInit()
         placeHolder.contentbackView.isHidden = true
         tableView?.backgroundView = placeHolder
    }
    
    
    override init() {
        super.init()

    }
    
    func refresh() {
        // Code to refresh table view
        if let block = self.refreshTable{
            block()
        }
    }
}

extension CharPixelTableDataSource : UITableViewDelegate , UITableViewDataSource{
    
    func reloadTable() {
        placeHolder.activityLoader.stopAnimating()
        self.tableView?.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + APP_CONSTANT.DISMISS_REFRESH_TIME_INTERVAL, execute: {
            self.refreshControl?.endRefreshing()
        })
    }
    
    
    func removeRefreshControle() {
        if refreshControl != nil {
            self.refreshControl?.endRefreshing()
            refreshControl?.removeFromSuperview()
            refreshControl = nil
        }
    }
    
    func showTableWithLeftRightDownAnimation(type:AnimationType) {
        
        if type == AnimationType.none{
            self.reloadTable()
            return
        }
        self.refreshControl?.endRefreshing()
        tableView?.isHidden = true
        tableView?.reloadData()
        placeHolder.activityLoader.stopAnimating()
        tableView?.isHidden = false
        
        let cells = tableView?.visibleCells
        
        for i in cells! {
            let cell: UITableViewCell = i as UITableViewCell
            switch type {
            case AnimationType.fromLeft:
                cell.transform = CGAffineTransform(translationX:  -tableView!.bounds.size.width, y: 0)
            case AnimationType.fromRight:
                cell.transform = CGAffineTransform(translationX:  tableView!.bounds.size.width, y: 0)
            case AnimationType.fromDown:
                cell.transform = CGAffineTransform(translationX:  0, y: tableView!.bounds.size.height)
                break
            default:
                cell.transform = CGAffineTransform(translationX:  tableView!.bounds.size.height, y: 0)
                
            }
        }
        
        var index = 0
        
        for a in cells! {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.0, delay: 0.1 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
    
   
    
    func showHideTable(showhide :Bool) {
        self.tableView?.isHidden = showhide
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let block = self.configureCellBlock{
            return block( indexPath)
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let block = self.cellSelect{
            block(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = returnRows?(section) ?? 0
        placeHolder?.contentbackView?.isHidden = (items == 0 && sectionsCount() <= 1 && !(placeHolder?.activityLoader.isAnimating ?? true)) ? false : true
        return items
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight?(section) ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerViewBlock?(section)  ?? nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsCount() 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getHeight?(indexPath) ?? 50.0
    }
}



//MARK: - IMAGE PICKER

class AssetPicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate, UIDocumentMenuDelegate {
    
    static let sharedInstance = AssetPicker()
    
    private lazy var cameraPicker: UIImagePickerController = {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        cameraPicker.allowsEditing = true
        return cameraPicker
    }()
    
    private lazy var videoCameraPicker: UIImagePickerController = {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        cameraPicker.allowsEditing = true
        cameraPicker.mediaTypes = [String(kUTTypeMovie)]
        return cameraPicker
    }()
    
    private lazy var singlePhotoPicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.navigationBar.isTranslucent = false
        imagePicker.navigationBar.barTintColor = UIColor.themeColor
        imagePicker.navigationBar.tintColor = .white
        let navigationTitleFont = UIFont(name: APP_CONSTANT.themeFontNormal, size: 18)!
        imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName : navigationTitleFont]
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        if UIDevice.current.userInterfaceIdiom == .pad {
            imagePicker.allowsEditing = false
        }else{
            imagePicker.allowsEditing = true
        }
        return imagePicker
    }()
    
    private lazy var singleVideoPicker: UIImagePickerController = {
        let videoPicker = UIImagePickerController()
        videoPicker.sourceType = .photoLibrary
        videoPicker.delegate = self
        if UIDevice.current.userInterfaceIdiom == .pad {
            videoPicker.allowsEditing = false
        }else{
            videoPicker.allowsEditing = true
        }
        videoPicker.mediaTypes = [String(kUTTypeMovie)]
        return videoPicker
    }()
    
    private func takePhotoAction(vc: UIViewController) -> UIAlertAction {
        return UIAlertAction(title: "Take a photo", style: .default) { _ in
            vc.present(self.cameraPicker, animated: true, completion: nil)
        }
    }
    
    private func chooseSinglePhotoFromLibraryAction(vc: UIViewController) -> UIAlertAction {
        return UIAlertAction(title: "Choose from library", style: .default) { _ in
            vc.present(self.singlePhotoPicker, animated: true, completion: nil)
        }
    }
    
    private func takeVideoAction(vc: UIViewController) -> UIAlertAction {
        return UIAlertAction(title: "Take a video", style: .default) { _ in
            vc.present(self.videoCameraPicker, animated: true, completion: nil)
        }
    }
    
    private func chooseSingleVideoFromLibraryAction(vc: UIViewController) -> UIAlertAction {
        return UIAlertAction(title: "Choose from library", style: .default) { _ in
            vc.present(self.singleVideoPicker, animated: true, completion: nil)
        }
    }
    
    private let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    private var pickSinglePhotoCompletionHandler: ((UIImage?) -> Void)?
    private var pickSingleVideoCompletionHandler: ((NSURL?) -> Void)?
    private var pickFileCompletionHandler: ((NSURL?) -> Void)?
    
    private var viewController: UIViewController?
    
    func pickPhoto(inViewController vc: UIViewController, sourceView: UIView? = nil, buttonItem: UIBarButtonItem? = nil, completionHandler: @escaping (UIImage?) -> Void) {
        self.pickSinglePhotoCompletionHandler = completionHandler
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(takePhotoAction(vc: vc))
        }
        alert.addAction(chooseSinglePhotoFromLibraryAction(vc: vc))
        alert.addAction(cancelAction)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            assert(sourceView != nil || buttonItem != nil,
                   "You must provide either sourceView or buttonItem to \(#function) when on an iPad")
            alert.popoverPresentationController?.sourceView = sourceView
            alert.popoverPresentationController?.barButtonItem = buttonItem
            if let sourceView = sourceView {
                alert.popoverPresentationController?.sourceRect = sourceView.bounds
            }
        }
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    func pickVideo(inViewController vc: UIViewController, sourceView: UIView? = nil, buttonItem: UIBarButtonItem? = nil, completionHandler: @escaping (NSURL?) -> Void) {
        self.pickSingleVideoCompletionHandler = completionHandler
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(takeVideoAction(vc: vc))
        }
        alert.addAction(chooseSingleVideoFromLibraryAction(vc: vc))
        alert.addAction(cancelAction)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            assert(sourceView != nil || buttonItem != nil,
                   "You must provide either sourceView or buttonItem to \(#function) when on an iPad")
            alert.popoverPresentationController?.sourceView = sourceView
            alert.popoverPresentationController?.barButtonItem = buttonItem
            if let sourceView = sourceView {
                alert.popoverPresentationController?.sourceRect = sourceView.bounds
            }
        }
        //HealthRecords
        vc.present(alert, animated: true, completion: nil)
    }
    
    func pickFile(inViewController vc: UIViewController, completionHandler: @escaping (NSURL?) -> Void) {
        self.viewController = vc
        self.pickFileCompletionHandler = completionHandler
        let documentMenuVC = UIDocumentMenuViewController(documentTypes: ["public.text", "public.data","public.pdf", "public.doc"], in: .import)

       // let documentMenuVC = UIDocumentMenuViewController(documentTypes: [String(kUTTypeContent)], in: .import)
        documentMenuVC.delegate = self
        vc.present(documentMenuVC, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        if mediaType == kUTTypeMovie {
            let videoURL = info[UIImagePickerControllerMediaURL] as! NSURL
            pickSingleVideoCompletionHandler?(videoURL)
        } else {
            let editedImage: UIImage? = info[UIImagePickerControllerEditedImage] as? UIImage
            let originalImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            let image = editedImage ?? originalImage
            pickSinglePhotoCompletionHandler?(image)
        }
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickSinglePhotoCompletionHandler?(nil)
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: UIDocumentPickerMenu
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        viewController?.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentMenuWasCancelled(documentMenu: UIDocumentMenuViewController) {
        pickFileCompletionHandler?(nil)
    }
    
    // MARK: UIDocumentPickerDelegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        pickFileCompletionHandler?(url as NSURL?)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        pickFileCompletionHandler?(nil)
    }
    
}
