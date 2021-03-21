//
//  QRCodeViewController.swift
//  ReadingRoomPRJ
//
//  Created by MCNC on 2021/02/21.
//

import UIKit

class QRCodeViewController: UIViewController {
    var qrCodeView: UIImageView!
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        qrCodeView = UIImageView()
        qrCodeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(qrCodeView)
        
        NSLayoutConstraint.activate([
            qrCodeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            qrCodeView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            qrCodeView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            qrCodeView.heightAnchor.constraint(equalTo: qrCodeView.widthAnchor)
        ])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        qrCodeView.image = createQRCode("test")
        qrCodeView.layer.magnificationFilter = CALayerContentsFilter(rawValue: kCISamplerFilterNearest)
        
        // Do any additional setup after loading the view.
    }
    func createQRCode(_ str: String) -> UIImage {
        let stringData = str.data(using: .utf8)
        
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")! // QR코드 생성 기능
        qrFilter.setValue(stringData, forKey: "inputMessage") // 만들 QR문자열
        //qrFilter.setValue("H", forKey: "inputCorrectionLevel") // 보정값 수준
        
        let qrImage = qrFilter.outputImage!
        let qrCode: UIImage = .init(ciImage: qrImage)
        
        
        return qrCode
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
