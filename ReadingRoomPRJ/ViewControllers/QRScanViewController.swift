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

//var tokenDic = Dictionary<String, String>()



class QRScanViewController: UIViewController {
    
    var readerView: QRReaderView!
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        readerView = QRReaderView.init(frame: view.frame)
        
        readerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(readerView)
        
        NSLayoutConstraint.activate([
            readerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            readerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            readerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            readerView.heightAnchor.constraint(equalTo: readerView.widthAnchor),
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
            self.readerView.stop(isStatusStop: false)
        }
    }
    
    @objc func scanButtonAction(_ sender: UIButton) {
        if self.readerView.isRunning {
            self.readerView.stop(isStatusStop: true)
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
            let okAction = UIAlertAction(title: "확인", style: .default, handler: {(alert: UIAlertAction!) in self.readerView.start()})
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        case let .stop(isButtonTap):
            if isButtonTap {
                title = "알림"
                message = "바코드 읽기를 멈추었습니다."
            } else {
                return
            }
        }
        
        
        

    }
    
    func requestConfirm(code: String) {
            let accountInfo = UserDefaults.standard.dictionary(forKey: "accountInfo")! as NSDictionary
            let id = accountInfo["id"] as! String
            let pw = accountInfo["pw"] as! String
            var param = [ "id":id, "password":pw ]
            RequestAPI.post(resource: "/room/reserve/my", param: param, responseData: "reservations", completion: { (result, response) in
                let reservations = response as! NSArray
                let data = reservations[0] as! NSDictionary
                if result {
                    let reservationId = data["reservationId"] as! String
                    let roomName = data["roomName"] as! String
                    let studentInfo = UserDefaults.standard.dictionary(forKey: "studentInfo")! as NSDictionary
                    let college = studentInfo["college"] as! String
                    param = [
                        "id":id,
                        "password" : pw,
                        "college" : college,
                        "roomName" : roomName,
                        "reservationId" : reservationId,
                        "token":code
                    ]
                    RequestAPI.post(resource: "/room/reserve/confirm", param: param, responseData: "reservation", completion: { (result, response) in
                        if result {
                            
                        } else {
                            
                        }
                    })
                } else {
                    print(response)
                }
            })
            
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
