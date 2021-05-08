//MainViewController.swift
//ReadingRoomPRJ
//Created by MCNC on 2021/02/18.

import UIKit
import Foundation
import PanModal
import Alamofire
import Photos

enum userType: String {
    case admin = "ADMIN"
    case student = "STUDENT"
}

class MainViewController: UIViewController {
    // UI 요소 정의
    static var reservationState = true
    static var newEndTime = 0
    static var reserveID = ""
    static var college = ""
    static var room = ""
    static var seat = 0
    static var confirmed = false
    static var userBeginTime = 0
    static var userEndTime = 0
    static var baseUserBeginTime = 0
    static var baseUserEndTime = 0

    var studentView : UIView!
    var studentImageView : UIView!
    
    var studentImage: UIImage!
    var studentOption: UIImage!
    
    var nameLabel: UILabel!
    var subNameLabel: UILabel!
    var studentDepartment: UILabel!
    var studentCollege: UILabel!
    
    var firstButton: UIButton!
    var secondButton: UIButton!
    var thirdButton: UIButton!

    var _seat = 0

    // 뷰 그려줌
    override func loadView() {
        super.loadView()
        print("view load")

        
        studentView = UIView()
        studentView.layer.shadowRadius = 5
        studentView.layer.cornerRadius = 10
        studentView.layer.shadowColor = #colorLiteral(red: 0.837041378, green: 0.8320663571, blue: 0.8408662081, alpha: 1)
        studentView.layer.shadowOpacity = 1.0
        studentView.layer.shadowOffset = CGSize.zero
        studentView.layer.shadowRadius = 10
        studentView.translatesAutoresizingMaskIntoConstraints = false
        studentView.backgroundColor = .white
        view.addSubview(studentView)

        let lineImg = UIImage(named: "line.png")
        let line = UIImageView(image: lineImg)
        line.translatesAutoresizingMaskIntoConstraints = false
        studentView.addSubview(line)

        studentImage = UIImage(named: "stdEx.png")
        studentImageView = UIImageView(image: studentImage)
        studentImageView.layer.borderWidth = 0.5
        studentImageView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        studentImageView.contentMode = .scaleAspectFit
        studentImageView.translatesAutoresizingMaskIntoConstraints = false
        studentView.addSubview(studentImageView)

        nameLabel = UILabel()     //이름
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .appFont(size: 24, family: .Bold)
        studentView.addSubview(nameLabel)

        subNameLabel = UILabel()       //학번
        subNameLabel.translatesAutoresizingMaskIntoConstraints = false
        subNameLabel.font = .appFont(size: 15, family: .Regular)
        subNameLabel.textColor = .appColor(.nickel)
        studentView.addSubview(subNameLabel)

        studentCollege = UILabel()       //단과대학
        studentCollege.translatesAutoresizingMaskIntoConstraints = false
        studentCollege.font = .appFont(size: 18, family: .Regular)
        studentView.addSubview(studentCollege)

        studentDepartment = UILabel()            //학과
        studentDepartment.translatesAutoresizingMaskIntoConstraints = false
        studentDepartment.font = .appFont(size: 18, family: .Regular)
        studentView.addSubview(studentDepartment)

        studentOption = UIImage(systemName: "gearshape")
        let studentOptionButton = UIButton()
        studentOptionButton.setImage(studentOption, for: .normal)
        studentOptionButton.tintColor = UIColor.appColor(.coal)
        studentOptionButton.translatesAutoresizingMaskIntoConstraints = false
        studentOptionButton.addTarget(self, action: #selector(self.optionView(_:)), for: .touchUpInside)
        studentView.addSubview(studentOptionButton)

        firstButton = UIButton(type: .custom)
        firstButton.titleLabel?.font = .appFont(size: 30, family: .Bold)
        firstButton.setBackgroundImage(UIImage(named: "btn_1.png"), for: .normal)
        firstButton.layer.masksToBounds = true
        firstButton.layer.cornerRadius = 10
        firstButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        firstButton.translatesAutoresizingMaskIntoConstraints = false
        firstButton.tintColor = .white
        view.addSubview(firstButton)

        secondButton = UIButton(type: .custom)
        secondButton.titleLabel?.font = .appFont(size: 30, family: .Bold)
        secondButton.setBackgroundImage(UIImage(named: "btn_2.png"), for: .normal)
        secondButton.layer.masksToBounds = true
        //secondButton.layer.cornerRadius = 10
        secondButton.translatesAutoresizingMaskIntoConstraints = false
        secondButton.tintColor = .white
        view.addSubview(secondButton)

        thirdButton = UIButton(type: .custom)
        thirdButton.titleLabel?.font = .appFont(size: 30, family: .Bold)
        thirdButton.setBackgroundImage(UIImage(named: "btn_2.png"), for: .normal)
        thirdButton.layer.masksToBounds = true
        thirdButton.layer.cornerRadius = 10
        thirdButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        thirdButton.translatesAutoresizingMaskIntoConstraints = false
        thirdButton.tintColor = .white
        view.addSubview(thirdButton)
        
        var marginHeight: CGFloat = 30
        if view.frame.height < 750 {
            marginHeight = 10
        }
        
        NSLayoutConstraint.activate([
            studentView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: marginHeight),
            studentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            studentView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.9),
            studentView.heightAnchor.constraint(equalTo: studentView.widthAnchor, multiplier: 0.6),

            studentImageView.centerYAnchor.constraint(equalTo: studentView.centerYAnchor),
            studentImageView.leadingAnchor.constraint(equalTo: studentView.leadingAnchor, constant: 20),
            studentImageView.heightAnchor.constraint(equalTo: studentView.heightAnchor, multiplier: 0.7),
            studentImageView.widthAnchor.constraint(equalTo: studentImageView.heightAnchor, multiplier: 0.7),

            line.topAnchor.constraint(equalTo: studentImageView.topAnchor),
            line.leadingAnchor.constraint(equalTo: studentImageView.trailingAnchor, constant: 20),
            line.widthAnchor.constraint(equalTo: studentImageView.widthAnchor, multiplier: 0.6),
            line.heightAnchor.constraint(equalToConstant: 3),

            nameLabel.leadingAnchor.constraint(equalTo: line.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 7),

            subNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            subNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),

            studentCollege.leadingAnchor.constraint(equalTo: subNameLabel.leadingAnchor),
            studentCollege.bottomAnchor.constraint(equalTo: studentImageView.bottomAnchor, constant: -7),
            
            studentDepartment.leadingAnchor.constraint(equalTo: line.leadingAnchor),
            studentDepartment.bottomAnchor.constraint(equalTo: studentCollege.topAnchor, constant: -5),

            studentOptionButton.topAnchor.constraint(equalTo: studentImageView.topAnchor),
            studentOptionButton.trailingAnchor.constraint(equalTo: studentView.trailingAnchor, constant: -20),
            studentOptionButton.widthAnchor.constraint(equalToConstant: 30),
            studentOptionButton.heightAnchor.constraint(equalToConstant: 30),

            firstButton.topAnchor.constraint(equalTo: studentView.bottomAnchor, constant: 25),
            firstButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstButton.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            firstButton.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.2, constant: -studentView.bounds.height),

            secondButton.topAnchor.constraint(equalTo: firstButton.bottomAnchor, constant: 0),
            secondButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondButton.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            secondButton.heightAnchor.constraint(equalTo: firstButton.heightAnchor),

            thirdButton.topAnchor.constraint(equalTo: secondButton.bottomAnchor, constant: 0),
            thirdButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            thirdButton.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            thirdButton.heightAnchor.constraint(equalTo: firstButton.heightAnchor)

        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        CameraAccess().requestCameraPermission()
        view.backgroundColor = .appColor(.mainBackgroundColor)
        checkUser()

        let logoView = UIImageView(frame: .zero)
        logoView.contentMode = .scaleAspectFit
        let logo = UIImage(named: "logoBlue.png")
        logoView.image = logo
        navigationItem.titleView = logoView

        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = .appColor(.mainBackgroundColor)
        navigationController?.navigationBar.isTranslucent = false // 진해지는거 방지
    }
    
   

    @objc func showMySeat(_ sender: Any) {

        let accountInfo = UserDefaults.standard.dictionary(forKey: "accountInfo")
        let id = accountInfo!["id"]
        let password = accountInfo!["pw"]

        let param = [
            "id": id as! String,
            "password": password as! String
        ] as [String : Any]


        RequestAPI.post(resource: "/room/reserve/my", param: param, responseData: "reservations", completion: {(result, response) in
            if (result) {
                if (response as! NSArray).isEqual(to: []) {
                print("예약정보 없음")
                //Toast.showToast(vc: self, message: "예약정보 없음")
                let userNotReserve = UIAlertController(title: "오류", message: "예약 정보가 없습니다.", preferredStyle: .alert)
                let userNotReserveOK = UIAlertAction(title: "확인", style: .default, handler: nil)
                userNotReserve.addAction(userNotReserveOK)
                self.present(userNotReserve, animated: true)
                }
                else {
                    self.presentPanModal(MySeatViewController())
                    let userReserveInfo = (response as! NSArray)[0] as! NSDictionary
                    MainViewController.reserveID = userReserveInfo["reservationId"] as! String
                    MainViewController.college = userReserveInfo["college"] as! String
                    MainViewController.room = userReserveInfo["roomName"] as! String
                    MainViewController.seat = userReserveInfo["seat"] as! Int
                    MainViewController.confirmed = userReserveInfo["confirmed"] as! Bool
                    MainViewController.userBeginTime = userReserveInfo["begin"] as! Int
                    MainViewController.userEndTime = userReserveInfo["end"] as! Int
                    self._seat = userReserveInfo["seat"] as! Int
                    

                }
            } else {
                print(response)
            }

        })
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
                    roomListAlert.view.tintColor = UIColor.appColor(.coal)
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


    func checkUser() {
        
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


            firstButton.setTitle("나의 자리 확인", for: .normal)
            secondButton.setTitle("자리 선택/예약", for: .normal)
            thirdButton.setTitle("자리 확정", for: .normal)

            firstButton.addTarget(self, action: #selector(self.showMySeat(_:)), for: .touchUpInside)
            secondButton.addTarget(self, action: #selector(self.openReserveView(_:)), for: .touchUpInside)
            thirdButton.addTarget(self, action: #selector(self.qrReader(_:)), for: .touchUpInside)
        }
    }



    @objc func qrReader(_ sender: Any) {


        let accountInfo = UserDefaults.standard.dictionary(forKey: "accountInfo")
        let id = accountInfo!["id"]
        let password = accountInfo!["pw"]

        let param = [
            "id": id as! String,
            "password": password as! String
        ] as [String : Any]



        RequestAPI.post(resource: "/room/reserve/my", param: param, responseData: "reservations", completion: {(result, response) in
            if (result) {
                //print((response as! Array<Any>).count) // 배열 아닐수도있는데 count 접근해서 예약없을때 무조건 크러쉬남. 이렇게 짜면 안됑 확인하면 지우삼
                if (response as! NSArray).isEqual(to: []) {
                    print("예약정보 없음")
                    let userNotReserve = UIAlertController(title: "오류", message: "예약 정보가 없습니다.", preferredStyle: .alert)
                    let userNotReserveOK = UIAlertAction(title: "확인", style: .default, handler: nil)
                    userNotReserve.addAction(userNotReserveOK)
                    self.present(userNotReserve, animated: true)
                    //Toast.showToast(vc: self, message: "예약정보 없음")
                } else {
                    
                    let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
                    switch cameraStatus {
                        case .authorized:
                            print("접근 허용됌")
                            let vc: QRScanViewController = QRScanViewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        case .denied:
                            print("접근 허용 안됌")
                            let alert = UIAlertController(title: "권한", message: "카메라 권한이 필요합니다.", preferredStyle: .alert)
                            let okButton = UIAlertAction(title: "이동", style: .default, handler: {(UIAlertAction) in
                                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                                }
                            })
                            alert.addAction(okButton)
                            self.present(alert, animated: true, completion: nil)
                            
                        default:
                            break
                        }
                    
                }
            } else {
                print(response)
            }
        })
    }
    @objc func optionView(_ sender: Any) {
            print("option")
            // test -> QR코드 찍기위해서 토큰 받아오게 바꿔놓음 잠시
            let isTestMode = true
            if isTestMode {
                let param = [
                    "id" : "#IT_ADMIN",
                    "password" : "123123",
                    "college" : "IT",
                    "roomName" : "2층"
                ]
                RequestAPI.post(resource: "/room/token", param: param, responseData: "token", completion: { (result, response) in
                    if (result) { // API 요청 성공
                       print("▶︎response data◀︎")
                       print(response)
                       // response 데이터에 접근하여 이후 로직 처리
                        let token = response as! String
                        print(token)
                        let vc: OptionViewController = OptionViewController()
                        self.navigationController?.pushViewController(vc, animated: true)

                        //let vc: TestPicker = TestPicker()
                        //self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let data = response as! NSDictionary
                        if (data["response"] != nil) {
                           let errorMessage = data["response"] as! String
                           print(errorMessage)
                           // 에러 메시지 alert or toast
                        } else {
                            print("알수없는 에러 : \(String(describing: data["error"]))")
                        }
                    }
                })
            } else {
                print("옵션뷰 통신 실패")
//                let vc: OptionViewController = OptionViewController()
//                navigationController?.pushViewController(vc, animated: true)
            }
        }
    
    

    @objc func showQr(_ sender: Any) {
        let vc: QRCodeViewController = QRCodeViewController()

        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func currentSeat(_ sender: Any) {     //관리자
        print("자리 현황")
    }

    @objc func roomOption(_ sender: Any) {      //관리자
        print("열람실 설정")
    }
}
