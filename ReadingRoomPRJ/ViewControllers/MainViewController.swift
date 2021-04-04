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

enum userType: String {
    case admin = "ADMIN"
    case student = "STUDENT"
}

class MainViewController: UIViewController {
    // UI 요소 정의
    var a = false        //추후 예약 여부에 따라서 bool 값으로 전달 예정
    
    var studentView : UIView!
    var studentImage: UIImage!
    var nameLabel: UILabel!
    var subNameLabel: UILabel!
    var studentDepartment: UILabel!
    var studentCollege: UILabel!
    var studentOption: UIImage!
    var firstButton: UIButton!
    var secondButton: UIButton!
    var thirdButton: UIButton!
    
    //mainView 에서 셀을 먼저 생성한 후 reserveView 에서 호출
    var rowCount:Int! // 가로 몇칸? -> it대학 기준 16
    var columnCount: Int!
    var totalCount:Int! // 전체 셀 개수. 2차원 배열 가로 * 세로
    var seatInfo: [Any] = []
    var seats = [Int:Int]()
    
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
        studentView.layer.cornerRadius = 10
        studentView.translatesAutoresizingMaskIntoConstraints = false
        studentView.backgroundColor = .white
        view.addSubview(studentView)
        
        let lineImg = UIImage(named: "line.png")
        let line = UIImageView(image: lineImg)
        line.translatesAutoresizingMaskIntoConstraints = false
        studentView.addSubview(line)
        
        studentImage = UIImage(named: "stdEx.png")
        let studentImageView = UIImageView(image: studentImage)
        studentImageView.translatesAutoresizingMaskIntoConstraints = false
        studentView.addSubview(studentImageView)
        
        nameLabel = UILabel()     //이름
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 30)
        studentView.addSubview(nameLabel)
            
        subNameLabel = UILabel()       //학번
        subNameLabel.translatesAutoresizingMaskIntoConstraints = false
        //studentID.text = "201635938"
        subNameLabel.font = UIFont.systemFont(ofSize: 20)
        studentView.addSubview(subNameLabel)
        
        studentCollege = UILabel()       //단과대학
        studentCollege.translatesAutoresizingMaskIntoConstraints = false
        studentCollege.font = UIFont.systemFont(ofSize: 20)
        studentView.addSubview(studentCollege)
        
        studentDepartment = UILabel()            //학과
        studentDepartment.translatesAutoresizingMaskIntoConstraints = false
        studentDepartment.font = UIFont.systemFont(ofSize: 20)
        studentView.addSubview(studentDepartment)
        
        studentOption = UIImage(named: "imgOption.jpg")
        let studentOptionButton = UIButton()
        studentOptionButton.setImage(studentOption, for: .normal)
        studentOptionButton.translatesAutoresizingMaskIntoConstraints = false
        studentOptionButton.addTarget(self, action: #selector(self.optionView(_:)), for: .touchUpInside)
        studentView.addSubview(studentOptionButton)
        
        firstButton = UIButton(type: .system)
        firstButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        firstButton.layer.cornerRadius = 20
        firstButton.translatesAutoresizingMaskIntoConstraints = false
        firstButton.backgroundColor = .white
        view.addSubview(firstButton)
        
        secondButton = UIButton(type: .system)
        secondButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        secondButton.layer.cornerRadius = 20
        secondButton.translatesAutoresizingMaskIntoConstraints = false
        secondButton.backgroundColor = .white
        view.addSubview(secondButton)
        
        thirdButton = UIButton(type: .system)
        thirdButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
        thirdButton.layer.cornerRadius = 20
        thirdButton.translatesAutoresizingMaskIntoConstraints = false
        thirdButton.backgroundColor = .white
        view.addSubview(thirdButton)
        
        NSLayoutConstraint.activate([
            studentView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
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
            
            nameLabel.leadingAnchor.constraint(equalTo: studentImageView.trailingAnchor, constant: 3),
            nameLabel.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 5),
            
            subNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            subNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 1),
            
            studentCollege.leadingAnchor.constraint(equalTo: studentImageView.trailingAnchor, constant: 3),
            studentCollege.bottomAnchor.constraint(equalTo: studentImageView.bottomAnchor),
            
            studentDepartment.leadingAnchor.constraint(equalTo: studentImageView.trailingAnchor, constant: 3),
            studentDepartment.bottomAnchor.constraint(equalTo: studentCollege.topAnchor, constant: 1),
            
            studentOptionButton.topAnchor.constraint(equalTo: studentImageView.topAnchor),
            studentOptionButton.trailingAnchor.constraint(equalTo: studentView.trailingAnchor, constant: -5),
            studentOptionButton.widthAnchor.constraint(equalToConstant: 30),
            studentOptionButton.heightAnchor.constraint(equalToConstant: 30),
            
            firstButton.topAnchor.constraint(equalTo: studentView.bottomAnchor, constant: 20),
            firstButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstButton.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            firstButton.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.2, constant: -studentView.bounds.height),
            
            secondButton.topAnchor.constraint(equalTo: firstButton.bottomAnchor, constant: 15),
            secondButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondButton.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            secondButton.heightAnchor.constraint(equalTo: firstButton.heightAnchor),
            
            thirdButton.topAnchor.constraint(equalTo: secondButton.bottomAnchor, constant: 15),
            thirdButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            thirdButton.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            thirdButton.heightAnchor.constraint(equalTo: firstButton.heightAnchor)
            
        ])
    } // end of loadView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        print("I'm test")
        //print(tokenDic)
        
        
        view.backgroundColor = UIColor.rgbColor(r: 244, g: 244, b: 244)
        
        let logoView = UIImageView(frame: .zero)
        logoView.contentMode = .scaleAspectFit
        let logo = UIImage(named: "logo_green.png")
        logoView.image = logo
        navigationItem.titleView = logoView
        
        navigationController?.navigationBar.shadowImage = UIImage() // 네비게이션 바 선 없애기
        navigationController?.navigationBar.barTintColor = UIColor.rgbColor(r: 244, g: 244, b: 244)
        navigationController?.navigationBar.isTranslucent = false // 진해지는거 방지
        
        if (userType.admin.rawValue == UserDefaults.standard.dictionary(forKey: "studentInfo")?["type"] as! String){
            
            let nameLabelText = UserDefaults.standard.dictionary(forKey: "studentInfo")?["college"]!
            nameLabel.text = (nameLabelText as! String)
            let subNameLabelText = "관리자"
            subNameLabel.text = (subNameLabelText)
            
            firstButton.setTitle("QR코드", for: .normal)
            secondButton.setTitle("자리 현황", for: .normal)
            thirdButton.setTitle("열람실 설정", for: .normal)
            
            firstButton.addTarget(self, action: #selector(showQr(_:)), for: .touchUpInside)
            secondButton.addTarget(self, action: #selector(currentSeat(_:)), for: .touchUpInside)
            thirdButton.addTarget(self, action: #selector(roomOption(_:)), for: .touchUpInside)
            
        } else {
            let nameLabelText = UserDefaults.standard.dictionary(forKey: "studentInfo")?["studentName"]!
            nameLabel.text = (nameLabelText as! String)
            let subNameLabelText = UserDefaults.standard.dictionary(forKey: "studentInfo")?["studentId"]!
            subNameLabel.text = (subNameLabelText as! String)
            let studentDepartmentText = UserDefaults.standard.dictionary(forKey: "studentInfo")?["department"]!
            studentDepartment.text = (studentDepartmentText as! String)
            let studentCollegeText = UserDefaults.standard.dictionary(forKey: "studentInfo")?["college"]!
            studentCollege.text = "(" + (studentCollegeText as! String) + ")"
           
            
            firstButton.setTitle("나의 자리", for: .normal)
            secondButton.setTitle("자리 선택/예약", for: .normal)
            thirdButton.setTitle("자리 확정", for: .normal)
            
            firstButton.addTarget(self, action: #selector(self.showMySeat(_:)), for: .touchUpInside)
            secondButton.addTarget(self, action: #selector(self.openReserveView(_:)), for: .touchUpInside)
            thirdButton.addTarget(self, action: #selector(self.qrReader(_:)), for: .touchUpInside)
        }
    }
    
    @objc func showMySeat(_ sender: Any) {
        self.presentPanModal(MySeatViewController())
    }
    
    @objc func openReserveView(_ sender: Any) {
        let college = UserDefaults.standard.dictionary(forKey: "studentInfo")!["college"] as! String //2층
        //let college = "TEST"      //방 5개
        // #boni --- API 통신 함수뺀걸로 바꿔놨어
        let param = [ "college":college ]
        RequestAPI.post(resource: "/rooms", param: param, responseData: "rooms", completion: { (result, response) in
            if (result) {
                let rooms = response as! NSArray
                
                let roomListAlert = UIAlertController(title: "열람실", message: "이용하실 단과대학의 열람실을 선택해주세요.", preferredStyle: .actionSheet)
                for i in 0..<rooms.count {
                    let room = rooms[i] as! NSDictionary
                    let roomListAction = UIAlertAction(title: room["roomName"] as? String, style: .default,
                                       handler: { action in self.showSelectedRoomSeats(index: i, selectedRoom: rooms[i] as! NSDictionary) })
                    roomListAlert.addAction(roomListAction)
                }
                let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                roomListAlert.addAction(cancelAction)
                self.present(roomListAlert, animated: true, completion: nil)
            } else {
                print("실패")
            }
        })
        
    }
    func showSelectedRoomSeats(index: Int, selectedRoom: NSDictionary) {
        // #boni --- userDefault로 세팅되있던거 전부 클래스화 해서 전역변수 사용으로 바꾸꿨어
        Room.shared = Room.init(room: selectedRoom)
        self.goReserveView((Any).self)
    }
    @objc func goReserveView(_ sender: Any) {
            
            let vc = ReserveViewController()
            vc.modalPresentationStyle = .fullScreen
           
            self.navigationController?.pushViewController(vc, animated: true)
           
       }

    
    
    @objc func qrReader(_ sender: Any) {
        let vc: QRScanViewController = QRScanViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func optionView(_ sender: Any) {
        print("option")
        let vc: OptionViewController = OptionViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showQr(_ sender: Any) {
        let vc: QRCodeViewController = QRCodeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func currentSeat(_ sender: Any) {
        print("자리 현황")
    }
    
    @objc func roomOption(_ sender: Any) {
        print("열람실 설정")
    }
}
