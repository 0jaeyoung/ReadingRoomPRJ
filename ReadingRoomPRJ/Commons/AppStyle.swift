//
//  RGBColorPick.swift
//  ReadingRoomPRJ
//
//  Created by 구본의 on 2021/03/25.
//

import UIKit

/*
 * desc : Describe app design extensions
 * date : 2021. 03.
 * author : jaeyoung
 * usage
    {Object}.backgroundColor = UIColor.appColor(.mainColor)
 */
class AppStyle: NSObject {
    
}
enum AssetsColor {
    case mainColor // 대표 하늘색
    case mainBackgroundColor // 대표 배경색
    case coal // 검정-1 대표 글꼴 색
    case moon // 검정-3
    case nickel // 검정-2
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
          return UIColor(displayP3Red: 133/255, green: 173/255, blue: 230/255, alpha: 1)
        case .mainBackgroundColor:
          return UIColor(displayP3Red: 237/255, green: 238/255, blue: 241/255, alpha: 1)
        case .coal:
            return UIColor(displayP3Red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        case .nickel:
            return UIColor.rgbColor(r: 102, g: 102, b: 102)
        case .moon:
            return UIColor.rgbColor(r: 153, g: 153, b: 153)
        }
    }
}

extension UIFont {
    
    enum Family: String {
        case Bold, Regular
    }
    
    static func appFont(size: CGFloat = 10, family: Family = .Regular) -> UIFont {
        let fm = (family == Family.Bold) ? "600" : "300"
        return UIFont(name: "Handon 3gyeopsal \(fm)g", size: size)!
    }
}

//let robotoBlack = UIFont.roboto(size: 10, family: .Black)
