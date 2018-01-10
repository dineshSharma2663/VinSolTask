//
//  APIClient.swift
//  Kid Circle
//
//  Created by Rohit Arora on 20/05/17.
//  Copyright © 2017 Rohit Arora. All rights reserved.
//
import UIKit
import Foundation

enum UploadMediaType : String {
    case image = "IMAGE"
    case video = "VIDEO"
    case audio = "AUDIO"
    case file = "FILE"
}

class APIClient: NSObject {
    //MARK: - Complete Payment
    static let sharedClient = APIClient()
    let reachability : Reachability!
    let session: URLSession
    var downloadTask : URLSessionDownloadTask!
    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        reachability = Reachability.init()
        self.session = URLSession(configuration: configuration)
        super.init()
    }
    
    func callAPIMethod(_ urlString : String, parameters: [String: AnyObject]?, method: Method,mediaParameterName : String = "",mediaFileName: String = "file", isHeaderRequired : Bool = false,showErrorMessage:Bool = false, isUploadingMedia : Bool = false, mediaType : UploadMediaType = .image,mediaData : Data? = nil ,mediaExtension : String = "jpeg", completion: @escaping (_ response: AnyObject?, _ success : Bool, _ error : String) -> Void) {
        if !(reachability?.isReachable)!{
            Singleton.shared.stopLoading()
            completion(nil, false, APP_CONSTANT.NO_INTERNET_MESSAGE)
            return
        }
        let url = URL(string: urlString)
        var request = URLRequest.request(url!, method: method, mediaParameterName : mediaParameterName, mediaFileName:mediaFileName,params: parameters,isUploadingMedia: isUploadingMedia,mediaType : mediaType, mediaData: mediaData, mediaExtension: mediaExtension)
        if let token = UserDefaults.standard.value(forKey: USER_DEFAULTS.AccessToken) as? String ,isHeaderRequired {
            request.allHTTPHeaderFields = ["authorization":"bearer \(token)"]
        }
        let task = self.session.dataTask(with: request) { (data, urlResponse, error) in
            DispatchQueue.main.async {
                Singleton.shared.stopLoading()
                if error != nil{
                    print(error ?? "")
                    if showErrorMessage {
                        Singleton.shared.showErrorMessage(message: error?.localizedDescription ?? "")
                    }
                    completion(nil, false, (error?.localizedDescription)!)
                    return
                }
                do {
                    var parsedDataDic = [String : Any]()
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    if let parsedDataArray = parsedData as? [[String:AnyObject]] {
                        parsedDataDic["data"] = parsedDataArray
                        completion(parsedDataDic as AnyObject, true, "")
                        
                    }else {
                        parsedDataDic = parsedData as? [String : Any] ?? [:]
                        completion(parsedDataDic as AnyObject, false, "")
                        
                        if let message = parsedDataDic["message"] as? String {
                            Singleton.shared.showErrorMessage(message: message)
                        }else if let message = parsedDataDic["error"] as? String {
                            Singleton.shared.showErrorMessage(message: message)
                        }
                    }
                    
                    
                } catch let error as NSError {
                    print(error)
                    completion([:] as AnyObject, false, (error.localizedDescription) )
                    
                }
                
            }
        }
        task.resume()
    }
}
