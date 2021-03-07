//
//  QRReaderView.swift
//  ReadingRoomPRJ
//
//  Created by MCNC on 2021/03/07.
//

import UIKit
import AVFoundation

enum ReaderStatus {
    // QR코드 읽음 상태, 성공/실패/멈춤
    case success(_ code: String?)
    case fail
    case stop(_ isButtonTap: Bool)
}

protocol ReaderViewDelegate: class {
    // QR코드 읽기 완료시 실행될 함수
    func readerComplete(status: ReaderStatus)
}

class QRReaderView: UIView {

    weak var delegate: ReaderViewDelegate?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    var centerGuideLineView: UIView?
    
    var captureSession: AVCaptureSession?
    
    var isRunning: Bool {
        guard let captureSession = self.captureSession else {
            return false
        }

        return captureSession.isRunning
    }

    let metadataObjectTypes: [AVMetadataObject.ObjectType] = [.qr]
    // 리더기로 인식가능한 코드 타입.
    // .upce, .code39, .code39Mod43, .code93, .code128, .ean8, .ean13, .aztec, .pdf417, .itf14, .dataMatrix, .interleaved2of5
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initialSetupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.initialSetupView()
    }
    
    private func initialSetupView() {
        self.clipsToBounds = true
        self.captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch let error {
            print(error.localizedDescription)
            return
        }

        guard let captureSession = self.captureSession else {
            self.fail()
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            self.fail()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = self.metadataObjectTypes
        } else {
            self.fail()
            return
        }
        
        self.setPreviewLayer()
        self.setCenterGuideLineView()
    }

    private func setPreviewLayer() {
        guard let captureSession = self.captureSession else {
            return
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = self.layer.bounds

        self.layer.addSublayer(previewLayer)

        self.previewLayer = previewLayer
    }

    private func setCenterGuideLineView() {
        let centerGuideLineView = UIView()
        centerGuideLineView.translatesAutoresizingMaskIntoConstraints = false
        centerGuideLineView.backgroundColor = #colorLiteral(red: 1, green: 0.5411764706, blue: 0.2392156863, alpha: 1)
        self.addSubview(centerGuideLineView)
        self.bringSubviewToFront(centerGuideLineView)

        centerGuideLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        centerGuideLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        centerGuideLineView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        centerGuideLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        self.centerGuideLineView = centerGuideLineView
    }
}

extension QRReaderView {
    func start() {
        self.captureSession?.startRunning()
    }
    
    func stop(isButtonTap: Bool) {
        self.captureSession?.stopRunning()
        
        self.delegate?.readerComplete(status: .stop(isButtonTap))
    }
    
    func fail() {
        self.delegate?.readerComplete(status: .fail)
        self.captureSession = nil
    }
    
    func found(code: String) {
        self.delegate?.readerComplete(status: .success(code))
    }
}

extension QRReaderView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        stop(isButtonTap: false)
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                let stringValue = readableObject.stringValue else {
                return
            }

            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
}
