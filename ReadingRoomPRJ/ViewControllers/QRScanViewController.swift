//
//  QRScanViewController.swift
//  ReadingRoomPRJ
//
//  Created by MCNC on 2021/03/07.
//

import UIKit
import AVFoundation

class QRScanViewController: UIViewController {
    
    var readerView: QRReaderView!
    var readButton: UIButton!
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        readerView = QRReaderView()
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
        
        self.readButton.layer.masksToBounds = true
        self.readButton.layer.cornerRadius = 15
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
        switch status {
        case let .success(code):
            guard let code = code else {
                title = "에러"
                message = "QR코드 or 바코드를 인식하지 못했습니다.\n다시 시도해주세요."
                break
            }

            title = "알림"
            message = "인식성공\n\(code)"
        case .fail:
            title = "에러"
            message = "QR코드 or 바코드를 인식하지 못했습니다.\n다시 시도해주세요."
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

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)

        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
