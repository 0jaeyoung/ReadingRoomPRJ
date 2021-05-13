
//
//  TestCell.swift
//  ReadingRoomPRJ
//
//  Created by 구본의 on 2021/03/14.
//
import UIKit

class CollectionCell: UICollectionViewCell {
    static let identifire = "CollectionCell"
    weak var viewController: UIViewController?
    
    @IBOutlet var backView: UIView!
    @IBOutlet var myButton: UIButton!
    @IBOutlet var myImageView: UIImageView!
    
    static var userSelectedSeat = ""
    
    var state: UIImage!

    @IBAction func clicked(_ sender: UIButton) {
        guard let selectedSeat = myButton.title(for: .normal) else {
            return
        }
        
        if CollectionCell.userSelectedSeat == myButton.title(for: .normal) ?? "" {
            // 같은 좌석 다시 선택
            return
        }
        
        state = myImageView.image
        myImageView.image = UIImage(named: "selectedSeat.png")
        CollectionCell.userSelectedSeat = selectedSeat
        NotificationCenter.default.post(name: Notification.Name("seatSelected"), object: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {   //값 초기화
        super.prepareForReuse()
        myImageView.image = nil
        myButton.setTitle("", for: .normal)
    }
}
