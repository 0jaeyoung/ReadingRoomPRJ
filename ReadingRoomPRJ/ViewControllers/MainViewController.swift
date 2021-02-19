//
//  MainViewController.swift
//  ReadingRoomPRJ
//
//  Created by MCNC on 2021/02/18.
//

import UIKit
import Foundation
import PanModal
import Alamofire

class MainViewController: UIViewController {
    // UI 요소 정의
    var a = false        //추후 예약 여부에 따라서 bool 값으로 전달 예정
    
    var studentView : UIView!
    var studentImage: UIImage!
    var studentName: UILabel!
    var studentID: UILabel!
    var studentMajor: UILabel!
    var studentDepartment: UILabel!
    var studentOption: UIImage!
    var myButton: UIButton!
    var reserveButton: UIButton!
    var checkinButton: UIButton!
    
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(300)
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(300)
    }
    
    
    
    
    // 뷰 그려줌
    override func loadView() {
        super.loadView()
        print("view load")
        
        
        studentView = UIView()
        studentView.translatesAutoresizingMaskIntoConstraints = false
        studentView.backgroundColor = .gray
        view.addSubview(studentView)
        
        let lineImg = UIImage(named: "line")
        let line = UIImageView(image: lineImg)
        line.translatesAutoresizingMaskIntoConstraints = false
        studentView.addSubview(line)
        
        studentImage = UIImage(named: "imgSmp")
        let studentImageView = UIImageView(image: studentImage)
        studentImageView.translatesAutoresizingMaskIntoConstraints = false
        studentView.addSubview(studentImageView)
        
        studentName = UILabel()     //이름
        studentName.translatesAutoresizingMaskIntoConstraints = false
        let studentNameText = UserDefaults.standard.dictionary(forKey: "studentInfo")?["name"]!
        studentName.text = (studentNameText as! String)
        //studentName.font = UIFont.fontNames(forFamilyName: "폰트명")
        studentName.font = UIFont.systemFont(ofSize: 30)
        studentView.addSubview(studentName)
            
        studentID = UILabel()       //학번
        studentID.translatesAutoresizingMaskIntoConstraints = false
        //studentID.text = "201635938"
        let studentIDText = UserDefaults.standard.dictionary(forKey: "studentInfo")?["studentId"]!
        studentID.text = (studentIDText as! String)
        studentID.font = UIFont.systemFont(ofSize: 20)
        studentView.addSubview(studentID)
        
        studentDepartment = UILabel()       //단과대학
        studentDepartment.translatesAutoresizingMaskIntoConstraints = false
        let studentDepartmentText = UserDefaults.standard.dictionary(forKey: "studentInfo")?["department"]!
        studentDepartment.text = (studentDepartmentText as! String)
        studentDepartment.font = UIFont.systemFont(ofSize: 20)
        studentView.addSubview(studentDepartment)
        
        studentMajor = UILabel()            //학과
        studentMajor.translatesAutoresizingMaskIntoConstraints = false
        let studentMajorText = UserDefaults.standard.dictionary(forKey: "studentInfo")?["type"]!
        studentMajor.text = (studentMajorText as! String)
        studentMajor.font = UIFont.systemFont(ofSize: 20)
        studentView.addSubview(studentMajor)
        
        studentOption = UIImage(named: "imgOption")
        let studentOptionButton = UIButton()
        studentOptionButton.setImage(studentOption, for: .normal)
        studentOptionButton.backgroundColor = .red
        studentOptionButton.translatesAutoresizingMaskIntoConstraints = false
        //studentOptionButton.addTarget(self, action: #selector(self.studen), for: .touchUpInside)
        studentView.addSubview(studentOptionButton)
        
        myButton = UIButton(type: .system)
        myButton.setTitle("나의 자리", for: .normal)
        myButton.translatesAutoresizingMaskIntoConstraints = false
        myButton.backgroundColor = .gray
        myButton.addTarget(self, action: #selector(self.showMySeat(_:)), for: .touchUpInside)
        view.addSubview(myButton)
        
        reserveButton = UIButton(type: .system)
        reserveButton.setTitle("자리 선택/예약", for: .normal)
        reserveButton.translatesAutoresizingMaskIntoConstraints = false
        reserveButton.backgroundColor = .gray
        reserveButton.addTarget(self, action: #selector(self.openView(_:)), for: .touchUpInside)
        view.addSubview(reserveButton)
        
        checkinButton = UIButton(type: .system)
        checkinButton.setTitle("자리 확정", for: .normal)
        checkinButton.translatesAutoresizingMaskIntoConstraints = false
        checkinButton.backgroundColor = .gray
        checkinButton.addTarget(self, action: #selector(self.showQr(_:)), for: .touchUpInside)
        view.addSubview(checkinButton)
        
        NSLayoutConstraint.activate([
            studentView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            studentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            studentView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            studentView.heightAnchor.constraint(equalTo: studentView.widthAnchor, multiplier: 0.5),
            
            studentImageView.centerYAnchor.constraint(equalTo: studentView.centerYAnchor),
            studentImageView.leadingAnchor.constraint(equalTo: studentView.leadingAnchor, constant: 5),
            studentImageView.heightAnchor.constraint(equalTo: studentView.heightAnchor, multiplier: 0.9),
            studentImageView.widthAnchor.constraint(equalTo: studentImageView.heightAnchor, multiplier: 0.8),
            
            line.topAnchor.constraint(equalTo: studentImageView.topAnchor),
            line.leadingAnchor.constraint(equalTo: studentImageView.trailingAnchor, constant: 3),
            line.widthAnchor.constraint(equalTo: studentImageView.widthAnchor, multiplier: 0.5),
            line.heightAnchor.constraint(equalToConstant: 5),
            
            studentName.leadingAnchor.constraint(equalTo: studentImageView.trailingAnchor, constant: 3),
            studentName.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 5),
            
            studentID.leadingAnchor.constraint(equalTo: studentName.leadingAnchor),
            studentID.topAnchor.constraint(equalTo: studentName.bottomAnchor, constant: 1),
            
            studentDepartment.leadingAnchor.constraint(equalTo: studentImageView.trailingAnchor, constant: 3),
            studentDepartment.bottomAnchor.constraint(equalTo: studentImageView.bottomAnchor),
            
            studentMajor.leadingAnchor.constraint(equalTo: studentImageView.trailingAnchor, constant: 3),
            studentMajor.bottomAnchor.constraint(equalTo: studentDepartment.topAnchor, constant: 1),
            
            studentOptionButton.topAnchor.constraint(equalTo: studentImageView.topAnchor),
            studentOptionButton.trailingAnchor.constraint(equalTo: studentView.trailingAnchor, constant: -5),
            studentOptionButton.widthAnchor.constraint(equalToConstant: 30),
            studentOptionButton.heightAnchor.constraint(equalToConstant: 30),
            
            myButton.topAnchor.constraint(equalTo: studentView.bottomAnchor, constant: 10),
            myButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            myButton.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.2, constant: -studentView.bounds.height),
            
            reserveButton.topAnchor.constraint(equalTo: myButton.bottomAnchor, constant: 5),
            reserveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reserveButton.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            reserveButton.heightAnchor.constraint(equalTo: myButton.heightAnchor),
            
            checkinButton.topAnchor.constraint(equalTo: reserveButton.bottomAnchor, constant: 5),
            checkinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkinButton.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            checkinButton.heightAnchor.constraint(equalTo: myButton.heightAnchor)
            
        ])
    } // end of loadView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print("view did load")
        // 저장한 학생 데이터 가져오기
        let studentInfo: NSDictionary = UserDefaults.standard.dictionary(forKey: "studentInfo")! as NSDictionary
       
        print("studentInfo 출력")
        
        
        
        
        
        
    }
    
    // [나의자리] 버튼 클릭 이벤트
    
    
    @objc func showMySeat(_ sender: Any) {
        
        
        self.presentPanModal(MySeatViewController())
    }
    
    @objc func openView(_ sender: Any) {
        print(sender)
        
        let vc: ReserveViewController = ReserveViewController()
        
        
        
        let nextPage = UIAlertController(title: "예약", message: "최대 예약 시간은 4시간 입니다", preferredStyle: UIAlertController.Style.alert)
        let nextPageAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {alertAction in self.present(vc, animated: true, completion: nil)})
        nextPage.addAction(nextPageAction)
        vc.modalPresentationStyle = .fullScreen
        present(nextPage, animated: true, completion: nil)
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)

        
        //여기 열 때 모든 자리 좌석 보여줌
        
        let college: String = "TEST"
        let room: String = "Test"


        let showSeatURL = "http://3.34.174.56:8080/room"
        let PARAM: Parameters = [

            "college": college,
            "room": room,

        ]

        let alamo = AF.request(showSeatURL, method: .get, parameters: PARAM).validate(statusCode: 200..<450)

        alamo.responseJSON(){ response in
            
            print("result::: \(response)")
            
            switch response.result {
            case .success(let value):
                print("success")
                if let jsonObj = value as? NSDictionary {
                    let resultMsg: String? = jsonObj.object(forKey: "message") as? String
                    let getResult: Bool? = jsonObj.object(forKey: "result") as? Bool
                    
                    if (resultMsg == "Success" && getResult == true) {
                        UserDefaults.standard.set(jsonObj.object(forKey: "room"), forKey: "roomInfo")
                        print("데이터 저장 성공")
                        
                        
                    }
                }
            case .failure(_):
                print("error")
            }
            
           
            
            }
        
        
        
        
        
        
    }
    
    
    @objc func showQr(_ sender: Any) {
        print(sender)
        let vc: MySeatViewController = MySeatViewController()
        vc.modalPresentationStyle = .formSheet
        self.present(vc, animated: true, completion: nil)
        //navigationController?.pushViewController(vc, animated: true)
    }
    
    

}
