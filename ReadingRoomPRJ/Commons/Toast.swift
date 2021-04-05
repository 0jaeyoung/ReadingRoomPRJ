//
//  Toast.swift
//  ReadingRoomPRJ
//
//  Created by MCNC on 2021/04/05.
//

import UIKit

class Toast: NSObject {
    static func showToast(vc: UIViewController, message: String) {
        let width_variable = 10
        let toastLabel = UILabel(frame: CGRect(x: width_variable, y: Int(vc.view.frame.size.height)-100, width: Int(vc.view.frame.size.width)-2*width_variable, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.layer.cornerRadius = 15
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.clipsToBounds = true
        vc.view.addSubview(toastLabel)
        //self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {toastLabel.alpha = 0.0}, completion: {(isCompleted) in toastLabel.removeFromSuperview()})
    }
}
