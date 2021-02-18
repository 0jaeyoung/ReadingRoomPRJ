//
//  ShowMySeat.swift
//  ReadingRoomPRJ
//
//  Created by 구본의 on 2021/02/18.
//

import Foundation
import UIKit
import PanModal

class ShowMySeat: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ShowMySeat: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil
    }
}

