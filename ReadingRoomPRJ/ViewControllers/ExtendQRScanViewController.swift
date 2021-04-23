//
//  QRScanViewController.swift
//  ReadingRoomPRJ
//
//  Created by MCNC on 2021/03/07.
//
import UIKit
import AVFoundation
import Alamofire


class ExtendQRScanViewController: UIViewController {
    static var extendToken = ""
    var readerView: ExtendQRReaderView!
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        readerView = ExtendQRReaderView.init(frame: view.frame)
        
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
        print("연장 뷰 출력")
        self.readerView.delegate = self
        self.readerView.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !self.readerView.isRunning {
            self.readerView.stop()
        }
    }
    
    @objc func scanButtonAction(_ sender: UIButton) {
        if self.readerView.isRunning {
            self.readerView.stop()
        } else {
            self.readerView.start()
        }

        sender.isSelected = self.readerView.isRunning
    }
}

extension ExtendQRScanViewController: ExtendReaderViewDelegate {
    
    func readerComplete(status: extendReaderStatus) {
        print(1000)
        var title = ""
        var message = ""
        //var scanedQRCode = ""
        
        switch status {
        case let .success(code):
            guard let code = code else {
                title = "에러"
                message = "QR코드 or 바코드를 인식하지 못했습니다.\n다시 시도해주세요."
                break
            }

            title = "알림"
            message = "인식성공\n\(code)"
            //scanedQRCode = code
            
            //기존 확정과 동일하게 extendToken값 전역변수로 저장
            ExtendQRScanViewController.extendToken = code
            reqeustExtend(code: code)
            
        case .fail:
            title = "에러"
            message = "QR코드 or 바코드를 인식하지 못했습니다.\n다시 시도해주세요."
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: {(alert: UIAlertAction!) in self.readerView.start()})
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        case .stop:
            title = "알림"
            message = "바코드 읽기를 멈추었습니다."
        }
        
    }
    
    
    
    func reqeustExtend(code: String) {
        let accountInfo = UserDefaults.standard.dictionary(forKey: "accountInfo")! as NSDictionary
        let id = accountInfo["id"] as! String
        let password = accountInfo["pw"] as! String
    
        let param = [
            "id": id,
            "password": password,
            "college": MySeatViewController.college,
            "roomName": MySeatViewController.room,
            "token": ExtendQRScanViewController.extendToken,
            "extendedTime": MySeatViewController.newEndTime,
            "reservationId": MySeatViewController.reserveID
        ] as [String : Any]

        RequestAPI.post(resource: "/room/reserve/extend", param: param, responseData: "reservation", completion: {(result, response) in
            print(result)
            if result {
                print("성공")
                print(response)
                MySeatViewController.newEndTime = 0
                self.dismiss(animated: true, completion: nil)
                MySeatViewController().dismiss(animated: true, completion: nil)
                
            } else {
                print("실패")
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
        
       
    }
}
