//
//  RequestAPI.swift
//  ReadingRoomPRJ
//
//  Created by 구본의 on 2021/03/25.
//
import UIKit
import Alamofire

/*
 * desc : API reauest, method=POST
 * date : 2021. 03. 25
 * author : jaeyoung
 * usage
     let param = [
         "key1" : value1,
         "key2" : value2
     ]
     RequestAPI.post(resource: "/{path}", param: param, responseData: "{data}", completion: { (result, response) in
         let data = response as! NSDictionary // (경우에 따라 NSArray, ... -> API 정의 확인)
         if (result) { // API 요청 성공
            print("▶︎response data◀︎")
            print(response)
            // response 데이터에 접근하여 이후 로직 처리
 
         } else {
             if (data["response"] != nil) {
                let errorMessage = data["response"] as! String
                print(errorMessgae)
                // 에러 메시지 alert or toast
             } else {
                 print("알수없는 에러 : \(String(describing: data["error"]))")
             }
         }
     })
 */

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
            case .success(let value): //통신만 확인
                NSLog("►request success◀︎")
                if let jsonObj = value as? NSDictionary {
                    let response = jsonObj["response"] as! String
                    let result = jsonObj["result"] as! Bool
                    
                    if result && (response=="SUCCESS") {
                        NSLog("►request result success◀︎")
                        resultData = jsonObj[responseData] as Any
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


