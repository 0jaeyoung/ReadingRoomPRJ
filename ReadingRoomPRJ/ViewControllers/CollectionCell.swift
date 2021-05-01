
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
    static var userSeatInfo = 0
    static var checkArr = ReserveViewController().stateArr
    static var countOne = 0
    
    var userSeat: Int!
    var k: Array<String>!
    var state = true
    

    @IBAction func clicked(_ sender: UIButton) {
       
        if myButton.currentTitle == "" {}
        
        else {
            let btnNum = Int(myButton.currentTitle ?? "0")
            if btnNum == nil {
                print("testERROR")
            } else {
                if CollectionCell.checkArr[btnNum!] == 0 && myImageView.image == UIImage(named: "emptySeat.png") && CollectionCell.countOne == 0 {
                    CollectionCell.countOne += 1
                    CollectionCell.checkArr[btnNum!] = 1
                    CollectionCell.userSeatInfo = btnNum!
                    myImageView.image = UIImage(named: "selectedSeat.png")
                    print(CollectionCell.countOne)
                    print("빈 좌석 선택")
                    CollectionCell.userSelectedSeat = myButton.title(for: .normal)!
                    
                    
                  //오류 발생
                } else if CollectionCell.checkArr[CollectionCell.userSeatInfo] == 1 && CollectionCell.checkArr[btnNum!] == 0 && myImageView.image == UIImage(named: "emptySeat.png") && CollectionCell.countOne >= 1 {
                    
                    let alert = UIAlertController(title: "경고", message: "하나의 좌석만 선택할 수 있습니다.", preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                    alert.view.tintColor = UIColor.appColor(.textColor)
                    alert.addAction(okButton)
                    viewController?.present(alert, animated: false, completion: nil)
                } else if CollectionCell.checkArr[btnNum!] == 1 && myImageView.image == UIImage(named: "selectedSeat.png") && CollectionCell.countOne == 1 {
                    
                    CollectionCell.countOne -= 1
                    CollectionCell.checkArr[btnNum!] = 0
                    myImageView.image = UIImage(named: "emptySeat.png")
                    print(CollectionCell.countOne)
                    print("같은 좌석 다시 클릭")
                    CollectionCell.userSelectedSeat = ""
                } else if myImageView.image == UIImage(named: "wall.png") || myImageView.image == UIImage(named: "door.jpeg") || myImageView.image == UIImage(named: "road.png") {
                    
                    print("좌석인 곳을 선택해 주세요")
                    print(CollectionCell.countOne)
                }
            }
        }
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
