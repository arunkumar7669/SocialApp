//
//  WebApi.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 10/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WebApi: NSObject {
//
    static let API_KEY = "base64:ATC+vljhHr3GdKMD7j69utCF+hUoaISYHwyFxBhOztI="
    static let BASE_URL = "http://cable.social/admincp/"
    
//    Web api code for hit api without authentication token
    static func webApiForPostRequestWithoutToken(_ url : String, _ params : Dictionary<String, String>, completion: @escaping (_ JSON: JSON)->()) {
        
        let header = ["apikey" : WebApi.API_KEY]
        let httpHeaders = HTTPHeaders(header)
        AF.upload(multipartFormData: { multiPart in
            for p in params {
                multiPart.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
            }
        }, to: url, method: .post, headers: httpHeaders) .uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }).responseJSON(completionHandler: { data in
            print("upload finished: \(data)")
            var swiftyJsonVar = JSON()
            if let json = data.data {
                do {
                    swiftyJsonVar = try JSON(data: json)
                }
                catch{
                print("JSON Error")
                    swiftyJsonVar = [:]
                }
            }else {
                swiftyJsonVar = [:]
            }
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                let loginVC = LoginViewController.init(nibName: "LoginViewController", bundle: nil)
                topController.navigationController?.pushViewController(loginVC, animated: true)
            }
            completion(swiftyJsonVar)
        })
    }
    
//    Web api code for hit api with authentication token
    static func webApiForPostRequestWithToken(_ url : String, _ params : Dictionary<String, String>, completion: @escaping (_ JSON: JSON)->()) {
        
        let header = ["apikey" : WebApi.API_KEY, "Authorization" : "Bearer \(UserDefaultOperations.getStringObject(ConstantStrings.AUTH_TOKEN))"]
        let httpHeaders = HTTPHeaders(header)
        AF.upload(multipartFormData: { multiPart in
            for p in params {
                multiPart.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
            }
        }, to: url, method: .post, headers: httpHeaders) .uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }).responseJSON(completionHandler: { data in
            print("upload finished: \(data)")
            var swiftyJsonVar = JSON()
            if let json = data.data {
                do {
                    swiftyJsonVar = try JSON(data: json)
                }
                catch{
                print("JSON Error")
                    swiftyJsonVar = [:]
                }
            }else {
                swiftyJsonVar = [:]
            }
            completion(swiftyJsonVar)
        })
    }
    
//    Web api code for hit Get api with authentication token
    static func webApiForGetRequestWithToken(_ url : String, completion: @escaping (_ JSON: JSON)->()) {
        
        let header = ["apikey" : WebApi.API_KEY, "Authorization" : "Bearer \(UserDefaultOperations.getStringObject(ConstantStrings.AUTH_TOKEN))"]
        let httpHeaders = HTTPHeaders(header)
        
        AF.request(url, method: .get, parameters: nil, headers: httpHeaders)
            .responseJSON { (response) in
                var swiftyJsonVar = JSON()
                if let json = response.data {
                    do {
                        swiftyJsonVar = try JSON(data: json)
                    }
                    catch{
                    print("JSON Error")
                        swiftyJsonVar = [:]
                    }
                }else {
                    swiftyJsonVar = [:]
                }
                completion(swiftyJsonVar)
        }
    }
}
