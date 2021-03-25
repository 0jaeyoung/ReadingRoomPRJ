//
//  TestCell.swift
//  ReadingRoomPRJ
//
//  Created by 구본의 on 2021/03/14.
//

import UIKit

class CollectionCell: UICollectionViewCell {

    
    static let identifire = "CollectionCell"
    
    @IBOutlet var backView: UIView!
    @IBOutlet var myButton: UIButton!
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var myLabel: UILabel!
    
    
    var state = true
    
    //전체 버튼에 대한 클릭 이벤트 함수
    @IBAction func clicked(_ sender: UIButton) {
        if myButton.title(for: .normal) == "" {
            
        } else {
            print(myButton.title(for: .normal) as Any)
       
            //좌석번호를 서버로 전달하기 위해서 userdefaults로 좌석 값 저장 -> Nil 값도 저장하기 때문에 확인 필요
            UserDefaults.standard.set(myButton.title(for: .normal), forKey: "selectedSeatNumber")
//            if sender.isSelected {
//                sender.isSelected = false
//                myButton.backgroundColor = .black
//                print("fasle")
//            } else {
//                sender.isSelected = true
//                myButton.backgroundColor = .yellow
//
//                print("true")
//            }
            
//            if myButton.backgroundColor == nil {
//                myButton.backgroundColor = .green
//            } else if myButton.backgroundColor == .green {
//                myButton.backgroundColor = nil
//            }
            if myImageView.image == UIImage(named: "emptySeat.png") {
                myImageView.image = UIImage(named: "userSeat.png")
            } else if myImageView.image == UIImage(named: "userSeat.png") {
                myImageView.image = UIImage(named: "emptySeat.png")
            }

        }
        
  
        
        
        
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        myLabel.text = ""
        myImageView.image = nil
        myButton.setTitle("", for: .normal)
        
    }

}
