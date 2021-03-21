//
//  TestCell.swift
//  ReadingRoomPRJ
//
//  Created by 구본의 on 2021/03/14.
//

import UIKit

class TestCell: UICollectionViewCell {

    
    static let identifire = "TestCell"
    
    @IBOutlet var backView: UIView!
    @IBOutlet var myButton: UIButton!
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var myLabel: UILabel!
    
    
    var state = true
    @IBAction func clicked(_ sender: UIButton) {
        if myButton.title(for: .normal) == "" {
            
        } else {
            print(myButton.title(for: .normal) as Any)
            
            UserDefaults.standard.set(myButton.title(for: .normal), forKey: "selectedSeatNumber")
            if sender.isSelected {
                sender.isSelected = false
                print("fasle")
            } else {
                sender.isSelected = true
                
                print("true")
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
