//
//  Networking.swift
//  Stripe
//
//  Created by Ben Guo on 7/7/15.
//
import UIKit
import Foundation

public enum Method: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    
    public var encodesParametersInURL : Bool {
        switch self {
        case .GET:
            return true
        default:
            return false
        }
    }
}

public enum ParameterEncoding {
    public static func queryString(_ parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for key in Array(parameters.keys).sorted() {
            let value: AnyObject! = parameters[key]
            components += self.queryComponents(key, value)
        }
        
        return (components.map { "\($0)=\($1)" } as [String]).joined(separator: "&")
    }
    
    public static func queryComponents(_ key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)[]", value)
            }
        } else if let _ = value as? NSNull {
            components += queryComponents("\(key)", "" as AnyObject)
        } else {
            components.append(contentsOf: [(escape(key), escape("\(value)"))])
        }
        
        return components
    }
    
    /// Returns a percent escaped string following RFC 3986 for query string formatting.
    public static func escape(_ string: String) -> String {
        let generalDelimiters = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimiters = "!$&'()*+,;="
        let legalURLCharactersToBeEscaped: CFString = (generalDelimiters + subDelimiters) as CFString
        return CFURLCreateStringByAddingPercentEscapes(nil, string as CFString!, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
    
}

 extension URLRequest {
    static func request(_ url: URL,
                               method: Method,mediaParameterName : String = "",mediaFileName: String = "file",
                               params: [String: AnyObject]?,isUploadingMedia : Bool,mediaType : UploadMediaType = .image, mediaData: Data?, mediaExtension: String) -> URLRequest {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = method.rawValue
        if params == nil {
            request.addParameters(nil, method: method, mediaParameterName: mediaParameterName, mediaFileName: mediaFileName, isUploadingMedia: isUploadingMedia, mediaType: mediaType, mediaData: mediaData, mediaExtension: mediaExtension)
        }else {
            request.addParameters(params!, method: method, mediaParameterName: mediaParameterName, mediaFileName: mediaFileName, isUploadingMedia: isUploadingMedia, mediaType: mediaType, mediaData: mediaData, mediaExtension: mediaExtension)
        }
        return request as URLRequest
    }
}

 extension NSMutableURLRequest {
    /// Adds the given parameters in the request for the given method
    func addParameters(_ params: [String: AnyObject]?, method: Method,mediaParameterName : String = "",mediaFileName: String = "file",isUploadingMedia : Bool,mediaType : UploadMediaType = .image, mediaData : Data?, mediaExtension : String = "jpeg") {
        if method.encodesParametersInURL {
            if params != nil {
                if var URLComponents = URLComponents(url: self.url!, resolvingAgainstBaseURL: false) {
                    URLComponents.percentEncodedQuery = (URLComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + ParameterEncoding.queryString(params!)
                    self.url = URLComponents.url
                }
            }
        }
        else {
            
            let boundaryConstant = "myRandomBoundary12345";
            var uploadData = Data()
            if isUploadingMedia {
                // add Media
                uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append("Content-Disposition: form-data; name=\"\(mediaParameterName)\"; filename=\"\(mediaFileName).\(mediaExtension)\"\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append("Content-Type: \(mediaType.rawValue.lowercased())/\(mediaExtension)\r\n\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append(mediaData!)
            }
            // add parameters
            if params != nil {
                for (key, value) in params! {
                    uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                    uploadData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".data(using: String.Encoding.utf8)!)
                }
            }
            uploadData.append("\r\n--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
            self.setValue("multipart/form-data; boundary=\(boundaryConstant)", forHTTPHeaderField: "Content-Type")
            self.httpBody = uploadData
        }
    }
}

public extension Data {
    public static func URLEncodedData(_ dict: [String: AnyObject]) -> Data? {
        return ParameterEncoding.queryString(dict).data(using: String.Encoding.utf8,
                                                        allowLossyConversion: false)
    }
}

public extension NSError {
    public static func networkingError(_ status: Int) -> NSError {
        return NSError(domain: "FailingStatusCode", code: status, userInfo: nil)
    }
}

