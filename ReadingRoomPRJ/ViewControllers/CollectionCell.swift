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
    //@IBOutlet var myLabel: UILabel!
    
    var userSeat: Int!
    var k: Array<String>!
    var state = true
    
    static var userSeatInfo = -10
    static var checkArr = ReserveViewController().stateArr
    static var countOne = 0
    //전체 버튼에 대한 클릭 이벤트 함수
    @IBAction func clicked(_ sender: UIButton) {
        print(myButton.currentTitle ?? 1)
        if myButton.currentTitle == "" {

        }
        
        
        
        else {
            //print(myButton.title(for: .normal) as Any)
            //print(ReserveViewController().stateArr)
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
                    UserDefaults.standard.set(myButton.title(for: .normal), forKey: "selectedSeatNumber")
                    
                    
                    
                } else if CollectionCell.checkArr[CollectionCell.userSeatInfo] == 1 && CollectionCell.checkArr[btnNum!] == 0 && myImageView.image == UIImage(named: "emptySeat.png") && CollectionCell.countOne >= 1 {
                    print("하나의 좌석만 선택할 수 있습니다.")
                    print(CollectionCell.countOne)
                    
                   
                    // view가 존재하지 않아서 알림창이 출력되지 않음..
                    let nextPage = UIAlertController(title: "경고", message: "하나의 좌석만 선택할 수 있습니다.", preferredStyle: UIAlertController.Style.alert)
                    let nextPageAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                    nextPage.addAction(nextPageAction)

                    viewController?.present(nextPage, animated: false, completion: nil)
                    
                    
                    
                } else if CollectionCell.checkArr[btnNum!] == 1 && myImageView.image == UIImage(named: "selectedSeat.png") && CollectionCell.countOne == 1 {
                    CollectionCell.countOne -= 1
                    CollectionCell.checkArr[btnNum!] = 0
                    myImageView.image = UIImage(named: "emptySeat.png")
                    print(CollectionCell.countOne)
                    print("같은 좌석 다시 클릭")
                } else if myImageView.image == UIImage(named: "wall.png") || myImageView.image == UIImage(named: "door.jpeg") || myImageView.image == UIImage(named: "road.png") {
                    print("좌석인 곳을 선택해 주세요")
                    print(CollectionCell.countOne)
                }
            }
            
            
            
            
            
            
            
//            if (CollectionCell.checkArr[btnNum!] == 0 && CollectionCell.countOne == 0) {
//                CollectionCell.checkArr[btnNum!] = 1
//                CollectionCell.countOne += 1
//            } else if (CollectionCell.checkArr[btnNum!] == 1 && CollectionCell.countOne == 0){
//                CollectionCell.checkArr[btnNum!] = 0
//                CollectionCell.countOne -= 1
//            } else {
//                print("예외")
//            }
//
            
           
            //print("1의 개수 : \(CollectionCell.countOne)")
            
//            if (CollectionCell.countOne) > 1 {
//                print("하나의 좌석만 선택할 수 있습니다.")
//            } else if (CollectionCell.checkArr[btnNum!] == 1 && CollectionCell.countOne == 0 && myImageView.image == UIImage(named: "selectedSeat.png")){
//                myImageView.image = UIImage(named: "emptySeat.png")
//            } else if(CollectionCell.checkArr[btnNum!] == 0 && CollectionCell.countOne == 1 && myImageView.image == UIImage(named: "emptySeat.png")){
//                myImageView.image = UIImage(named: "selectedSeat.png")
//            }
//
//            if myImageView.image == UIImage(named: "emptySeat.png") {
//                myImageView.image = UIImage(named: "selectedSeat.png")
//
//
//
//            } else if myImageView.image == UIImage(named: "selectedSeat.png") {
//                myImageView.image = UIImage(named: "emptySeat.png")
//
//            }

        }





    }
    
   
    
    
    
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //myLabel.text = ""
        myImageView.image = nil
        myButton.setTitle("", for: .normal)
        
    }

}
