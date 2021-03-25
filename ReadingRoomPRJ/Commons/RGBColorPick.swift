//
//  RGBColorPick.swift
//  ReadingRoomPRJ
//
//  Created by 구본의 on 2021/03/25.
//

import UIKit

class RGBColorPick: NSObject {
    
}
enum AssetsColor {
    // 대표 색
    case mainColor

    // 대표 배경색
    case mainBackgroundColor

    // 자주 쓰는 색 정의
}

extension UIColor {
    static func rgbColor(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        let red = CGFloat(r/255.0)
        let green = CGFloat(g/255.0)
        let blue = CGFloat(b/255.0)
        return UIColor(displayP3Red: red, green: green, blue: blue, alpha: 1)
    }

    // 사용 : sample.backgroundColor = UIColor.appColor(.mainColor)
    static func appColor(_ name: AssetsColor) -> UIColor {
        switch name {
        case .mainColor:
          return UIColor(displayP3Red: 12/255, green: 205/255, blue: 163/255, alpha: 1)
        case .mainBackgroundColor:
          return UIColor(displayP3Red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        }
    }
}
