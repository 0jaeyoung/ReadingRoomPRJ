//
//  ViewController.swift
//  test1
//
//  Created by 구본의 on 2021/01/29.
//
import UIKit
//import PanModal


class MySeatViewController: UIViewController {
    
    
    var mySeat: UILabel!
    var location: UILabel!
    var seatNum: UILabel!
    var reserveTime: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
   
    override func loadView() {
        view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        mySeat = UILabel()
        mySeat.translatesAutoresizingMaskIntoConstraints = false
        mySeat.textAlignment = .center
        mySeat.text = "나의 자리"
        mySeat.font = UIFont.systemFont(ofSize: 30)
        mySeat.textColor = .black
        mySeat.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        view.addSubview(mySeat)
        
        
        location = UILabel()
        location.translatesAutoresizingMaskIntoConstraints = false
        location.text = "장소: " + "IT융합대학 열람실"
        location.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(location)
        
        seatNum = UILabel()
        seatNum.translatesAutoresizingMaskIntoConstraints = false
        seatNum.text = "자리 번호: " + "12"
        seatNum.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(seatNum)
        
        reserveTime = UILabel()
        reserveTime.translatesAutoresizingMaskIntoConstraints = false
        reserveTime.text = "예약 시간: " + "12:00" + " ~ " + "14:00"
        reserveTime.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(reserveTime)
        
        let extend = UIButton(type: .system)
        extend.translatesAutoresizingMaskIntoConstraints = false
        extend.setTitle("연장", for: .normal)
        extend.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        extend.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        view.addSubview(extend)
        
        
        let returned = UIButton(type: .system)
        returned.translatesAutoresizingMaskIntoConstraints = false
        returned.setTitle("반납", for: .normal)
        returned.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        returned.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        view.addSubview(returned)
        
        
        
        NSLayoutConstraint.activate([
            mySeat.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mySeat.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            mySeat.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),

            location.topAnchor.constraint(equalTo: mySeat.bottomAnchor, constant: 25),
            location.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            seatNum.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 10),
            seatNum.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            reserveTime.topAnchor.constraint(equalTo: seatNum.bottomAnchor, constant: 10),
            reserveTime.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            extend.topAnchor.constraint(equalTo: reserveTime.bottomAnchor, constant: 20),
            extend.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            extend.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4),
            extend.heightAnchor.constraint(equalToConstant: 45),
            
            returned.topAnchor.constraint(equalTo: reserveTime.bottomAnchor, constant: 20),
            returned.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            returned.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4),
            returned.heightAnchor.constraint(equalToConstant: 45)
            
        ])
        
    }
    
}


//extension MySeatViewController: PanModalPresentable {
//    var panScrollable: UIScrollView? {
//        return nil
//    }
//
//    var shortFormHeight: PanModalHeight {
//        return .contentHeight(300)
//    }
//
//    var longFormHeight: PanModalHeight {
//        return .contentHeight(300)
//    }
//
//    var anchorModalToLongForm: Bool {
//        return true
//    }
//}
