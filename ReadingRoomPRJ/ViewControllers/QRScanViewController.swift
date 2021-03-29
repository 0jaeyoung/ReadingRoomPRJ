//
//  QRScanViewController.swift
//  ReadingRoomPRJ
//
//  Created by MCNC on 2021/03/07.
//

import UIKit
import AVFoundation
import Alamofire

import UIKit
import AVFoundation
import Alamofire

var tokenDic = Dictionary<String, String>()



class QRScanViewController: UIViewController {
    
    var readerView: QRReaderView!
    var readButton: UIButton!
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        readerView = QRReaderView.init(frame: view.frame)
        readButton = UIButton()
        
        readerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(readerView)
        
        readButton.translatesAutoresizingMaskIntoConstraints = false
        readButton.addTarget(self, action: #selector(scanButtonAction), for: .touchUpInside)
        view.addSubview(readButton)
        
        NSLayoutConstraint.activate([
            readerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            readerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            readerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            readerView.heightAnchor.constraint(equalTo: readerView.widthAnchor),
            
            readButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            readButton.topAnchor.constraint(equalTo: readerView.bottomAnchor, constant: 20),
            readButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            readButton.heightAnchor.constraint(equalTo: readButton.widthAnchor, multiplier: 0.5)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.readerView.delegate = self
        self.readerView.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !self.readerView.isRunning {
            self.readerView.stop(isButtonTap: false)
        }
    }
    
    @objc func scanButtonAction(_ sender: UIButton) {
        if self.readerView.isRunning {
            self.readerView.stop(isButtonTap: true)
        } else {
            self.readerView.start()
        }

        sender.isSelected = self.readerView.isRunning
    }
}

extension QRScanViewController: ReaderViewDelegate {
    func readerComplete(status: ReaderStatus) {

        var title = ""
        var message = ""
        var scanedQRCode = ""
        
        switch status {
        case let .success(code):
            guard let code = code else {
                title = "에러"
                message = "QR코드 or 바코드를 인식하지 못했습니다.\n다시 시도해주세요."
                break
            }

            title = "알림"
            message = "인식성공\n\(code)"
            scanedQRCode = code
            
            requestConfirm(code: code)
            
        case .fail:
            title = "에러"
            message = "QR코드 or 바코드를 인식하지 못했습니다.\n다시 시도해주세요."
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        case let .stop(isButtonTap):
            if isButtonTap {
                title = "알림"
                message = "바코드 읽기를 멈추었습니다."
                self.readButton.isSelected = readerView.isRunning
            } else {
                self.readButton.isSelected = readerView.isRunning
                return
            }
        }
        
        
        

    }
    
    func requestConfirm(code: String) {
        
        
        let userID: String = UserDefaults.standard.dictionary(forKey: "studentInfo")?["id"]! as! String
        let userPW: String = UserDefaults.standard.dictionary(forKey: "studentInfo")?["password"]! as! String
        let userURL = "http://3.34.174.56:8080/room/myReservation"
        
        let PARAMETER: Parameters = [
            "id": userID,
            "password": userPW
        ]
        let myReservationAlamo = AF.request(userURL, method: .post, parameters: PARAMETER).validate(statusCode: 200..<450)
        
        myReservationAlamo.responseJSON() { response in
            switch response.result {
            case .success(let v):
                if let jsonObj = v as? NSDictionary {
                    let getResult: Bool? = jsonObj.object(forKey: "result") as? Bool
                    if getResult! {
                        let mySeat: NSArray = jsonObj.object(forKey: "reservations") as! NSArray
                        
                        print("확정을 위한 나의 정보에 접근했습니다.")
                        let mySeatInfo = mySeat[0] as! NSDictionary
                        
                        //값 비교를 위해서 myReservation -> cancel 로 진행
                        let URL = "http://3.34.174.56:8080/room/confirm"
                        let PARAM: Parameters = [
                            "id":UserDefaults.standard.dictionary(forKey: "studentInfo")?["id"]! as! String,
                            "password":UserDefaults.standard.dictionary(forKey: "studentInfo")?["password"]! as! String,
                            "token":code,
                            "studentId":UserDefaults.standard.dictionary(forKey: "studentInfo")?["studentId"]! as! String,
                            "end": mySeatInfo["end"] as! Int,
                            "begin": mySeatInfo["begin"] as! Int,
                            "time": mySeatInfo["time"] as! Int,
                            "seat": mySeatInfo["seat"] as! Int,
                            "room":"2층",
                            "college":UserDefaults.standard.dictionary(forKey: "studentInfo")?["college"]! as! String
                        ]
                        
                        tokenDic[UserDefaults.standard.dictionary(forKey: "studentInfo")?["studentId"]! as! String] = code
                        UserDefaults.standard.set(tokenDic, forKey: "tokenDic")
                        let alamo = AF.request(URL, method: .post, parameters: PARAM).validate()
                        alamo.responseJSON() { response in
                            print("===API:REQUEST:CONFIRM:RESULT===")
                            print(response)
                            
                            switch response.result {
                            case .success(let value):
                                //성공
                                self.readerView.stop(isButtonTap: true)
                                self.showToast(controller: self, message: "예약 확정되었습니다.")
                                self.navigationController?.popViewController(animated: true)
                            case .failure(let error):
                                //실패
                                print(error)
                                self.showToast(controller: self, message: "다시 시도 해주세요.")
                            }
                
                        }
                    }
                }
            case .failure(_):
                print("error")
            }
        }
        
        
        
        
        
        
        
        
        }
        
    
    
    func showToast(controller: UIViewController, message: String) {
        let width_variable = 10
        let toastLabel = UILabel(frame: CGRect(x: width_variable, y: Int(self.view.frame.size.height)-100, width: Int(view.frame.size.width)-2*width_variable, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.layer.cornerRadius = 15
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.clipsToBounds = true
        self.navigationController?.view.addSubview(toastLabel)
        //self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
                        toastLabel.alpha = 0.0}
                       , completion: {(isCompleted) in
                                       toastLabel.removeFromSuperview()
                       })
        
        /*
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .lightGray
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
            self.navigationController?.popViewController(animated: true)
        }
        */
    }
}
