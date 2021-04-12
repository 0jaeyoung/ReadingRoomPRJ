//
//  ViewController.swift
//  test1
//
//  Created by 구본의 on 2021/01/29.
//



import UIKit
import PanModal
import Alamofire

class MySeatViewController: UIViewController {
    
    static var reserveID = ""
    static var college = ""
    static var room = ""
    static var confirmed = false
    static var endTimeForExtend = 0
    var _seat = 0
    var mySeat: UILabel!
    var location: UILabel!
    var seatNum: UILabel!
    var reserveStartTime: UILabel!
    var reserveEndTime: UILabel!
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large) //서버 통신 대기를 위한 스피너 생성
    
    
    var testPickerView: UIDatePicker!
    
    
    var extend: UIButton!
    var returned: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.title = "자리확정"
        
    }

    
    
   
    override func loadView() {
        print("로드뷰 출력")
        super.loadView()
        view = UIView()
        view.backgroundColor = UIColor.appColor(.mainBackgroundColor)
        
        //스피너 생성 코드
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        self.myInfo()
   
    }
    
    
    //myReservation API 통해서 예약한 유저의 정보 가져오는 함수
    func myInfo() {
        
        print((UserDefaults.standard.dictionary(forKey: "studentInfo") as Any) as! Dictionary<String, Any>)
        
        print("유저의 좌석 정보를 보여줍니다.")
        let accountInfo = UserDefaults.standard.dictionary(forKey: "accountInfo")! as Dictionary

        
        let myReservedURL = "http://3.34.174.56:8080/room/reserve/my"
        let PARAM: Parameters = [
            "id": accountInfo["id"] as! String,
            "password": accountInfo["pw"] as! String
        ]
        
        let alamo = AF.request(myReservedURL, method: .post, parameters: PARAM).validate(statusCode: 200..<450)
        
        alamo.responseJSON() { [self] response in
            switch response.result {
            case .success(let value):
                spinner.stopAnimating()
                print(value)
                print(type(of: value))
                if let jsonObj = value as? NSDictionary {
                    print(jsonObj["result"]!)
                    let getResult: Bool! = (jsonObj.object(forKey: "result") as! Bool)
                    print("getresult :: \(getResult!)")
                    if getResult! {
                        let mySeatInfo: NSArray = jsonObj.object(forKey: "reservations") as! NSArray
                        print(getResult!)
                        print("123456789")
                        let k = mySeatInfo[0] as! NSDictionary
                        MySeatViewController.reserveID = k["reservationId"] as! String
                        MySeatViewController.college = k["college"] as! String
                        MySeatViewController.room = k["roomName"] as! String
                        MySeatViewController.confirmed = k["confirmed"] as! Bool
                        MySeatViewController.endTimeForExtend = k["end"] as! Int
                        _seat = k["seat"] as! Int
                        //예약을 하지 않은 상태일 경우 배열 크기 비교를 통해서 확인. 추후 텍스트가 아닌 별도 이미지 파일로 교체 예정
                        if mySeatInfo.count == 0 {
                            print("사용자의 예약 내역이 없습니다.")
                            
                        } else {    //예약된 내역이 있을 경우(확정여부와는 상관 x) = 길이 != 0
                            let length = mySeatInfo.count
                            let userCurrentInfo = mySeatInfo[length - 1] as! Dictionary<String, Any>    //이전에 사용자 정보 계속 저장한다고 했어서 맨 마지막 요소 불러옴. 저장 안한다면 0으로 해도 무관
                            print(userCurrentInfo)
                            mySeat = UILabel()
                            mySeat.translatesAutoresizingMaskIntoConstraints = false
                            mySeat.textAlignment = .center
                            mySeat.text = "나의 자리"
                            mySeat.font = UIFont.systemFont(ofSize: 30)
                            mySeat.textColor = .black
                            
                            view.addSubview(mySeat)
                            
                            location = UILabel()
                            location.translatesAutoresizingMaskIntoConstraints = false
                            location.text = "장소: \(MySeatViewController.college) \(MySeatViewController.room) "
                            location.font = UIFont.systemFont(ofSize: 20)
                            view.addSubview(location)
                            
                            seatNum = UILabel()
                            seatNum.translatesAutoresizingMaskIntoConstraints = false
                            seatNum.text = "자리 번호: \((userCurrentInfo["seat"]!))"
                            seatNum.font = UIFont.systemFont(ofSize: 20)
                            view.addSubview(seatNum)
                            
                            
                            let beginTime = userCurrentInfo["begin"] as! Int
                            let endTime = userCurrentInfo["end"] as! Int
                            let beginTimeInterval = (TimeInterval(beginTime)) / 1000     //9시간 시차 때문에 32,400,000 더해줌
                            let endTimeInterval = (TimeInterval(endTime)) / 1000
                            var insertBeginTime = Date(timeIntervalSince1970: beginTimeInterval)    //long값으로 된 시간값을 바꿔줌
                            let insertEndTime = Date(timeIntervalSince1970: endTimeInterval)
                            
                            
                            
                            let timeFormatter = DateFormatter()
                            timeFormatter.dateFormat = "HH시 mm분"
                            var finalStart = timeFormatter.string(from: insertBeginTime)
                            var finalEnd = timeFormatter.string(from: insertEndTime)
                            
                            reserveStartTime = UILabel()
                            reserveStartTime.translatesAutoresizingMaskIntoConstraints = false
                            reserveStartTime.text = "이용시간: \(finalStart) ~ \(finalEnd)"
                            reserveStartTime.font = UIFont.systemFont(ofSize: 20)
                            view.addSubview(reserveStartTime)
                       
                            //확정 여부를 나눠서 연장버튼 클릭 이벤트 조절
                            if MySeatViewController.confirmed {
                                extend = UIButton(type: .system)
                                extend.translatesAutoresizingMaskIntoConstraints = false
                                extend.setTitle("연장", for: .normal)
                                extend.backgroundColor = UIColor.appColor(.mainColor)
                                extend.tintColor = .white
                                extend.layer.cornerRadius = 5
                                
                                extend.addTarget(self, action: #selector(self.clickExtend(_:)), for: .touchUpInside)
                                extend.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
                                
                                view.addSubview(extend)
                                
                            } else {
                                extend = UIButton(type: .system)
                                extend.translatesAutoresizingMaskIntoConstraints = false
                                extend.setTitle("확정", for: .normal)
                                extend.backgroundColor = UIColor.appColor(.mainColor)
                                extend.tintColor = .white
                                extend.layer.cornerRadius = 5
                                extend.addTarget(self, action: #selector(self.text(_:)), for: .touchUpInside)
                                extend.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
                                
                                //extend.isEnabled = false
                                view.addSubview(extend)
                                
                            }
                            
                            
                            
                            
                            returned = UIButton(type: .system)
                            returned.translatesAutoresizingMaskIntoConstraints = false
                            returned.setTitle("반납", for: .normal)
                            returned.addTarget(self, action: #selector(self.clickReturn(_:)), for: .touchUpInside)
                            returned.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
                            returned.backgroundColor = UIColor.appColor(.mainColor)
                            returned.tintColor = .white
                            returned.layer.cornerRadius = 5
                            
                            
                            
                            view.addSubview(returned)
                            
                            NSLayoutConstraint.activate([
                                
                                mySeat.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                mySeat.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
                                mySeat.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),

                                location.topAnchor.constraint(equalTo: mySeat.bottomAnchor, constant: 25),
                                location.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
                                
                                seatNum.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 15),
                                seatNum.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
                                            
                                reserveStartTime.topAnchor.constraint(equalTo: seatNum.bottomAnchor, constant: 15),
                                reserveStartTime.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
                                            
                                extend.topAnchor.constraint(equalTo: reserveStartTime.bottomAnchor, constant: 25),
                                extend.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -5),
                                extend.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4),
                                extend.heightAnchor.constraint(equalToConstant: 50),
                                
                                returned.topAnchor.constraint(equalTo: reserveStartTime.bottomAnchor, constant: 25),
                                returned.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
                                returned.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4),
                                returned.heightAnchor.constraint(equalToConstant: 50)
                                
                            ])
                        }
                    }
                    else {
                        print(getResult!)
                        
                        print("좌석정보를 불러올 수 없습니다.")
                    }
                }
                
            case .failure(_):
                print("통신 실패")
            }
        }
    }
    
    
    @objc func text(_ sender: Any) {
        //self.navigationController?.pushViewController(QRScanViewController, animated: true)
    }
    
    
        
    @objc func clickExtend(_ sender: Any) { //alert 생성
        print("연장 버튼 클릭")
        let college = MySeatViewController.college, roomName = MySeatViewController.room // 내자리에서 가져오는 정보
        let param = [ "college":college, "roomName":roomName]
        
        let mySeatNumber = _seat // 내자리에서 가져오는 정보
        
        RequestAPI.post(resource: "/room", param: param, responseData: "room", completion: {(result, response) in
            if (result) {
                let reservedSeat = (response as! NSDictionary)["reserved"] as! NSArray
                let reservedList = reservedSeat[mySeatNumber] as! NSArray
                print(reservedList)
                for item in reservedList {
                    let res = item as! NSDictionary
                    print("==예약 찬 시간==")
                    print(res["begin"]!)
                    print("~")
                    print(res["end"]!)
                }
            } else {
                print(response)
            }
        })

        
        let addTime: [Int : Int] = [30: 1800000, 60: 3600000, 90: 5400000, 120: 7200000]    //tlrks duswkd qoduf todtjd
        
       
        
        let extend = UIAlertController(title: "연장", message: "얼마나 더 공부하실 껀가요?", preferredStyle: UIAlertController.Style.alert)
        let time30 = UIAlertAction(title: "30분", style: UIAlertAction.Style.default, handler: { [self]action in self.seatExtend(key: addTime[30]!)})
        let time60 = UIAlertAction(title: "60분", style: UIAlertAction.Style.default, handler: { [self]action in self.seatExtend(key: addTime[60]!)})
        let time90 = UIAlertAction(title: "90분", style: UIAlertAction.Style.default, handler: { [self]action in self.seatExtend(key: addTime[90]!)})
        let time120 = UIAlertAction(title: "120분", style: UIAlertAction.Style.default, handler: { [self]action in self.seatExtend(key: addTime[120]!)})
        let cancel = UIAlertAction(title: "취소", style: UIAlertAction.Style.destructive, handler: nil)
        extend.addAction(time30)
        extend.addAction(time60)
        extend.addAction(time90)
        extend.addAction(time120)
        extend.addAction(cancel)
        
        present(extend, animated: true, completion: nil)
    }
    
    
    
    func seatExtend(key: Int) {
        print("시간을 연장을 위해 세팅합니다")
    
        let accountInfo = UserDefaults.standard.dictionary(forKey: "accountInfo")! as NSDictionary
        let id = accountInfo["id"] as! String
        let password = accountInfo["pw"] as! String
        
        
        
        let param = [
            "id": id,
            "password": password,
            "college": MySeatViewController.college,
            "roomName": MySeatViewController.room,
            "token": QRScanViewController.token,
            "extendedTime": MySeatViewController.endTimeForExtend + key,
            "reservationId": MySeatViewController.reserveID
        
        ] as [String : Any]
        
        print(MySeatViewController.endTimeForExtend + key)
        
        
        
        RequestAPI.post(resource: "/room/reserve/extend", param: param, responseData: "reservation", completion: {(result, response) in
            print(result)
            if result {
                print("성공")
                print(response)
                
            } else {
                print("실패")
               
            }
        })
    }
    
    
    
    
    
    @objc func clickReturn(_ sender: Any) {
        print("반납 버튼 클릭")
        let bannab = UIAlertController(title: "반납", message: "좌석을 반납 하시겠어요??", preferredStyle: UIAlertController.Style.alert)
        let no = UIAlertAction(title: "취소", style: UIAlertAction.Style.destructive, handler: nil)
        let yes = UIAlertAction(title: "반납", style: UIAlertAction.Style.default, handler: { [self]action in self.seatReturn()})
        bannab.addAction(no)
        bannab.addAction(yes)
        present(bannab, animated: true, completion: nil)
    }
    
    
    
    
    
    func seatReturn() { //myReservation 에서 예약 여부 확인 후 cancel api 호출함 -> 서버 통신 2번 이루어지게 됌
        print("반납 버튼이 눌렸습니다.")
        spinner.startAnimating()
        
        let accountInfo = UserDefaults.standard.dictionary(forKey: "accountInfo")! as NSDictionary
        let id = accountInfo["id"] as! String
        let password = accountInfo["pw"] as! String
        
        let param = [
            "id": id,
            "password": password,
            "college": MySeatViewController.college,
            "roomName": MySeatViewController.room,
            "reservationId": MySeatViewController.reserveID
        ] as [String : Any]
        
        RequestAPI.post(resource: "/room/reserve/cancel", param: param, responseData: "reservation", completion: {(result, response) in
            if result {
                print("성공")
                print(response)
                self.spinner.stopAnimating()
                Toast.showToast(vc: self.presentingViewController!, message: "좌석 반납이 완료되었습니다.")
                self.dismiss(animated: true, completion: nil)
            } else {
                print("실패")
                print(response)
                self.spinner.stopAnimating()
            }
        })
        
    }
    
    
    
    
    func showToast(controller: UIViewController, message: String) { //좌석 반납시 토스트 띄어줌.
        print("토스트 출력")
        let width_variable = 10
        let toastLabel = UILabel(frame: CGRect(x: width_variable, y: Int(self.view.frame.size.height)-100, width: Int(view.frame.size.width)-2*width_variable, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.layer.cornerRadius = 15
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        //self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {toastLabel.alpha = 0.0}, completion: {(isCompleted) in toastLabel.removeFromSuperview()})
    }
}

//판모달
extension MySeatViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(300)
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(300)
    }

    var anchorModalToLongForm: Bool {
        return true
    }
}
