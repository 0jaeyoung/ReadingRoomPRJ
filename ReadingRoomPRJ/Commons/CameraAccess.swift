//
//  CameraAccess.swift
//  ReadingRoomPRJ
//
//  Created by 구본의 on 2021/05/03.
//

import Foundation
import Photos

class CameraAccess {
    func requestCameraPermission(){
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            if granted {
                print("Camera: 권한 허용")
                //self.dismiss(animated: true, completion: nil)
                
            } else {
                print("Camera: 권한 거부")
            }
        })
    }
}
