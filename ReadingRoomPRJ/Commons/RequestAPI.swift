//
//  RequestAPI.swift
//  ReadingRoomPRJ
//
//  Created by 구본의 on 2021/03/25.
//
import UIKit
import Alamofire

class RequestAPI: NSObject {
    static func post(resource:String, param: Dictionary<String, Any>, responseData: String, completion: @escaping (_ result: Bool,_ resultDic: Any)->()){
        var resultData: Any = ()
        
        let hostURL = "http://3.34.174.56:8080"
        let requestURL = hostURL + resource
        let requestParam: Parameters = param
        
        let sendRequest = AF.request(requestURL, method: .post, parameters: requestParam).validate()
        NSLog("►request start◀︎")
        NSLog("URL: \(requestURL), PARAMETERS: \(requestParam)")
        
        sendRequest.responseJSON() { response in
            switch response.result {
            case .success(let value):
                NSLog("►request success◀︎")
                if let jsonObj = value as? NSDictionary {
                    let message = jsonObj["message"] as! String
                    let result = jsonObj["result"] as! Bool
                    
                    if result && (message=="Success") {
                        NSLog("►request result success◀︎")
                        resultData = jsonObj[responseData]!
                        completion(true, resultData)
                    } else {
                        NSLog("►request result failed◀︎")
                        resultData = jsonObj
                        completion(false, resultData)
                    }
                } else {
                    NSLog("►request result cannot be convert to NSDictionary◀︎")
                    completion(false, [:])
                }
            case .failure(let error):
                NSLog("►request failed◀︎")
                NSLog("Alamo request failed, error description: \(error)")
                
                if error.isInvalidURLError {
                    NSLog("is Invalid URL")
                }
                completion(false, ["error":error])
            }
        }
        
    }
}
