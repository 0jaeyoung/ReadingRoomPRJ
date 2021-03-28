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
    
    
    var mySeat: UILabel!
    var location: UILabel!
    var seatNum: UILabel!
    var reserveStartTime: UILabel!
    var reserveEndTime: UILabel!
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large) //서버 통신 대기를 위한 스피너 생성
    
    var extend: UIButton!
    var returned: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("1213")
        //print(UserDefaults.standard.dictionary(forKey: "tokenDic")!["201735906"] as! String)
        print("디드 로드뷰")
        self.title = "자리확정"
        
    }

    
    
   
    override func loadView() {
        print("로드뷰 출력")
        super.loadView()
        view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
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
        
        
        
        print("유저의 좌석 정보를 보여줍니다.")
        let ID: String = UserDefaults.standard.dictionary(forKey: "studentInfo")?["id"]! as! String
        let PW: String = UserDefaults.standard.dictionary(forKey: "studentInfo")?["password"]! as! String
    
        let myReservedURL = "http://3.34.174.56:8080/room/myReservation"
        let PARAM: Parameters = [
            "id": ID,
            "password": PW
        ]
        
        let alamo = AF.request(myReservedURL, method: .post, parameters: PARAM).validate(statusCode: 200..<450)
        
        alamo.responseJSON() { [self] response in
            switch response.result {
            case .success(let value):
                spinner.stopAnimating()
                print(value)
                if let jsonObj = value as? NSDictionary {
                    let getResult: Bool? = jsonObj.object(forKey: "result") as? Bool
                    print("getresult :: \(getResult!)")
                    if getResult! {
                        let mySeatInfo: NSArray = jsonObj.object(forKey: "reservations") as! NSArray
                        print(getResult!)
                        
                        print(mySeatInfo)
                        
                        //예약을 하지 않은 상태일 경우 배열 크기 비교를 통해서 확인. 추후 텍스트가 아닌 별도 이미지 파일로 교체 예정
                        if mySeatInfo.count == 0 {
                            print("사용자의 예약 내역이 없습니다.")
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
                            location.text = "장소: " + "예약을 진행해 주세요."
                            location.font = UIFont.systemFont(ofSize: 20)
                            view.addSubview(location)
                            
                            seatNum = UILabel()
                            seatNum.translatesAutoresizingMaskIntoConstraints = false
                            seatNum.text = "자리 번호: 예약을 진행해 주세요."
                            seatNum.font = UIFont.systemFont(ofSize: 20)
                            view.addSubview(seatNum)
                            
                            reserveStartTime = UILabel()
                            reserveStartTime.translatesAutoresizingMaskIntoConstraints = false
                            reserveStartTime.text = "시작 시간: " + "예약을 진행해 주세요."
                            reserveStartTime.font = UIFont.systemFont(ofSize: 20)
                            view.addSubview(reserveStartTime)
                            
                            
                            reserveEndTime = UILabel()
                            reserveEndTime.translatesAutoresizingMaskIntoConstraints = false
                            reserveEndTime.text = "종료 시간: " + "예약을 진행해 주세요."
                            reserveEndTime.font = UIFont.systemFont(ofSize: 20)
                            view.addSubview(reserveEndTime)
                            
                            extend = UIButton(type: .system)
                            extend.translatesAutoresizingMaskIntoConstraints = false
                            extend.setTitle("연장", for: .normal)
                            extend.addTarget(self, action: #selector(self.clickExtend(_:)), for: .touchUpInside)
                            extend.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
                            extend.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                            extend.isEnabled = false    //예약된 내역이 없기 때문에 연장 버튼 비활성화
                            view.addSubview(extend)
                            
                            
                            returned = UIButton(type: .system)
                            returned.translatesAutoresizingMaskIntoConstraints = false
                            returned.setTitle("반납", for: .normal)
                            returned.addTarget(self, action: #selector(self.clickReturn(_:)), for: .touchUpInside)
                            returned.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
                            returned.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                            returned.isEnabled = false   //예약된 내역이 없기 때문에 반납 버튼 비활성화
                            view.addSubview(returned)
                            

                            
                            NSLayoutConstraint.activate([
                                mySeat.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                mySeat.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
                                mySeat.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),

                                location.topAnchor.constraint(equalTo: mySeat.bottomAnchor, constant: 25),
                                location.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                                
                                seatNum.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 10),
                                seatNum.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                                
                                reserveStartTime.topAnchor.constraint(equalTo: seatNum.bottomAnchor, constant: 10),
                                reserveStartTime.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                                
                                reserveEndTime.topAnchor.constraint(equalTo: reserveStartTime.bottomAnchor, constant: 10),
                                reserveEndTime.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                                
                                extend.topAnchor.constraint(equalTo: reserveEndTime.bottomAnchor, constant: 20),
                                extend.trailingAnchor.constraint(equalTo: view.centerXAnchor),
                                extend.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4),
                                extend.heightAnchor.constraint(equalToConstant: 45),
                                
                                returned.topAnchor.constraint(equalTo: reserveEndTime.bottomAnchor, constant: 20),
                                returned.leadingAnchor.constraint(equalTo: view.centerXAnchor),
                                returned.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4),
                                returned.heightAnchor.constraint(equalToConstant: 45)
                                
                                
                                
                            ])
                            
                            
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
                            mySeat.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
                            view.addSubview(mySeat)
                            
                            location = UILabel()
                            location.translatesAutoresizingMaskIntoConstraints = false
                            location.text = "장소: \(String(describing: userCurrentInfo["college"]!))"
                            location.font = UIFont.systemFont(ofSize: 20)
                            view.addSubview(location)
                            
                            seatNum = UILabel()
                            seatNum.translatesAutoresizingMaskIntoConstraints = false
                            seatNum.text = "자리 번호: \((userCurrentInfo["seat"]!))"
                            seatNum.font = UIFont.systemFont(ofSize: 20)
                            view.addSubview(seatNum)
                            
                            
                            let beginTime = userCurrentInfo["begin"] as! Int
                            let endTime = userCurrentInfo["end"] as! Int
                            let beginTimeInterval = TimeInterval(beginTime) / 1000       //9시간 시차 때문에 32,400,000 더해줌
                            let endTimeInterval = TimeInterval(endTime) / 1000
                            let insertBeginTime = Date(timeIntervalSince1970: beginTimeInterval)    //long값으로 된 시간값을 바꿔줌
                            let insertEndTime = Date(timeIntervalSince1970: endTimeInterval)
                            
                            reserveStartTime = UILabel()
                            reserveStartTime.translatesAutoresizingMaskIntoConstraints = false
                            reserveStartTime.text = "시작시간: \(insertBeginTime)"
                            reserveStartTime.font = UIFont.systemFont(ofSize: 20)
                            view.addSubview(reserveStartTime)
                            
                            reserveEndTime = UILabel()
                            reserveEndTime.translatesAutoresizingMaskIntoConstraints = false
                            reserveEndTime.text = "종료시간: \(insertEndTime)"
                            reserveEndTime.font = UIFont.systemFont(ofSize: 20)
                            view.addSubview(reserveEndTime)
                            
                            extend = UIButton(type: .system)
                            extend.translatesAutoresizingMaskIntoConstraints = false
                            extend.setTitle("연장", for: .normal)
                            extend.addTarget(self, action: #selector(self.clickExtend(_:)), for: .touchUpInside)
                            extend.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
                            extend.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                            view.addSubview(extend)
                            
                            
                            returned = UIButton(type: .system)
                            returned.translatesAutoresizingMaskIntoConstraints = false
                            returned.setTitle("반납", for: .normal)
                            returned.addTarget(self, action: #selector(self.clickReturn(_:)), for: .touchUpInside)
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
                                
                                reserveStartTime.topAnchor.constraint(equalTo: seatNum.bottomAnchor, constant: 10),
                                reserveStartTime.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                                
                                reserveEndTime.topAnchor.constraint(equalTo: reserveStartTime.bottomAnchor, constant: 10),
                                reserveEndTime.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                                
                                extend.topAnchor.constraint(equalTo: reserveEndTime.bottomAnchor, constant: 20),
                                extend.trailingAnchor.constraint(equalTo: view.centerXAnchor),
                                extend.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4),
                                extend.heightAnchor.constraint(equalToConstant: 45),
                                
                                returned.topAnchor.constraint(equalTo: reserveEndTime.bottomAnchor, constant: 20),
                                returned.leadingAnchor.constraint(equalTo: view.centerXAnchor),
                                returned.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4),
                                returned.heightAnchor.constraint(equalToConstant: 45)
                                
                            ])
                            
                            
                        }
                        
                  
                    }
                    else {
                        print(getResult!)
                        
                        print("예약이 불가능합니다..")
                    }
                    
                }
                
            case .failure(_):
                print("통신 실패")
            }
            
            
            }
    
    
    
    
    }
    
    
        
    @objc func clickExtend(_ sender: Any) { //alert 생성
        print("연장 버튼 클릭")
        let extend = UIAlertController(title: "연장", message: "얼마나 더 공부하실 껀가요?", preferredStyle: UIAlertController.Style.alert)
        let time30 = UIAlertAction(title: "30분", style: UIAlertAction.Style.default, handler: { [self]action in self.seatExtend()})
        let time60 = UIAlertAction(title: "60분", style: UIAlertAction.Style.default, handler: nil)
        let time90 = UIAlertAction(title: "90분", style: UIAlertAction.Style.default, handler: nil)
        let time120 = UIAlertAction(title: "120분", style: UIAlertAction.Style.default, handler: nil)
        let cancel = UIAlertAction(title: "취소", style: UIAlertAction.Style.destructive, handler: nil)
        extend.addAction(time30)
        extend.addAction(time60)
        extend.addAction(time90)
        extend.addAction(time120)
        extend.addAction(cancel)
        
        present(extend, animated: true, completion: nil)
    }
    
    
    func seatExtend() { //연장 api 사용 방법 확인되면 구현 예정 현재는 예약된 좌석 확인용으로 사용중
        print("시간을 연장을 위해 세팅합니다")
    
        //myreservation -> token -> extend api 순으로 넘어감
        let ID: String = UserDefaults.standard.dictionary(forKey: "studentInfo")?["id"]! as! String
        let PW: String = UserDefaults.standard.dictionary(forKey: "studentInfo")?["password"]! as! String
        let myReservedURL = "http://3.34.174.56:8080/room/myReservation"
        let myReservePARAM: Parameters = [
            "id": ID,
            "password": PW
        ]
        
        let myReserveAlamo = AF.request(myReservedURL, method: .post, parameters: myReservePARAM).validate(statusCode: 200..<450)
        myReserveAlamo.responseJSON() { response in
            switch response.result {
            case .success(let value):
                if let jsonObj = value as? NSDictionary {
                    let getResult: Bool? = jsonObj.object(forKey: "result") as? Bool
                    if getResult! {
                        let mySeat: NSArray = jsonObj.object(forKey: "reservations") as! NSArray
                        
                        
                        let mySeatInfo = mySeat[0] as! NSDictionary
                        
                        //값 비교를 위해서 myReservation -> cancel 로 진행
                        
                        print("898989")
                        print(mySeatInfo)
                        
                        let studentId: String = mySeatInfo["studentId"] as! String
                        let college: String = mySeatInfo["college"] as! String
                        let room: String = mySeatInfo["room"] as! String
                        let seat: Int = mySeatInfo["seat"] as! Int
                        let time: Int = mySeatInfo["time"] as! Int
                        let begin: Int = mySeatInfo["begin"] as! Int
                        let end: Int = mySeatInfo["end"] as! Int
                        //let ID: String = UserDefaults.standard.dictionary(forKey: "studentInfo")?["id"]! as! String
                        //let PW: String = UserDefaults.standard.dictionary(forKey: "studentInfo")?["password"]! as! String
                        let token: String = UserDefaults.standard.dictionary(forKey: "tokenDic")![studentId] as! String
                        let extendURL = "http://3.34.174.56:8080/room/extend"
                        let extendedTime = 1800000
                        
                        print(token)
                        //토큰을 가져오기 위한 파라미터 설정
                        let extendPARAM: Parameters = [
                            "id": ID,
                            "password": PW,
                            "token": token,
                            "studentId": studentId,
                            "room": room,
                            "college": college,
                            "seat": seat,
                            "time": time,
                            "begin": begin,
                            "end": end,
                            "extendedTime": extendedTime
                        ]
                        
                        
                        //print(QRScanViewController.requestConfirm().code)
                        
                        let extendAlamo = AF.request(extendURL, method: .post, parameters: extendPARAM).validate(statusCode: 200..<450)
                        extendAlamo.responseJSON() { [self] response in
                            switch response.result {
                            
                            case .success(let extendValue):
                                print("시간을 연장합니다.")
                                print(extendValue)
                                print("시간이 연장되었습니다.")
                            case .failure(_):
                                print("err")
                            }
                            
                        }
                        

                    }
                }
            case .failure(_):
                print("error")
            }
        }
        
        
        
        
        
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
        
        
        let userID: String = UserDefaults.standard.dictionary(forKey: "studentInfo")?["id"]! as! String
        let userPW: String = UserDefaults.standard.dictionary(forKey: "studentInfo")?["password"]! as! String
        let userURL = "http://3.34.174.56:8080/room/myReservation"
        
        let PARAMETER: Parameters = [
            "id": userID,
            "password": userPW
        ]
        
        let myReservationAlamo = AF.request(userURL, method: .post, parameters: PARAMETER).validate(statusCode: 200..<450)
        
        myReservationAlamo.responseJSON() { response in
            switch response.result {
            case .success(let v):
                if let jsonObj = v as? NSDictionary {
                    let getResult: Bool? = jsonObj.object(forKey: "result") as? Bool
                    if getResult! {
                        let mySeat: NSArray = jsonObj.object(forKey: "reservations") as! NSArray
                        
                        print("취소를 위한 나의 정보에 접근했습니다.")
                        let mySeatInfo = mySeat[0] as! NSDictionary
                        
                        //값 비교를 위해서 myReservation -> cancel 로 진행
                        
                        let studentId: String = mySeatInfo["studentId"] as! String
                        let college: String = mySeatInfo["college"] as! String
                        let room: String = mySeatInfo["room"] as! String
                        let seat: Int = mySeatInfo["seat"] as! Int
                        let time: Int = mySeatInfo["time"] as! Int
                        let begin: Int = mySeatInfo["begin"] as! Int
                        let end: Int = mySeatInfo["end"] as! Int
                        let ID: String = UserDefaults.standard.dictionary(forKey: "studentInfo")?["id"]! as! String
                        let PW: String = UserDefaults.standard.dictionary(forKey: "studentInfo")?["password"]! as! String
                        let cancelURL = "http://3.34.174.56:8080/room/cancel"
                        
                        let PARAM: Parameters = [
                            "id": ID,
                            "password": PW,
                            "studentId": studentId,
                            "end": end,
                            "begin": begin,
                            "time": time,
                            "seat": seat,
                            "room": room,
                            "college": college
                        ]
                        
                        let alamo = AF.request(cancelURL, method: .post, parameters: PARAM).validate(statusCode: 200..<450)
                        alamo.responseJSON() { [self] response in
                            switch response.result {
                            case .success(let value):
                                print("좌석을 반납합니다")
                                print(value)
                                if let jsonObj = value as? NSDictionary {
                                    let getResult: Bool? = jsonObj.object(forKey: "result") as? Bool
                                    //let getMessage: String? = jsonObj.object(forKey: "message") as? String
                                    print("getresult :: \(getResult!)")
                                    if getResult! {
                                        spinner.stopAnimating()
                                        let mySeatInfo: NSDictionary = jsonObj.object(forKey: "reservation") as! NSDictionary
                                        print(mySeatInfo["reserved"] as Any)
                                        print("좌석을 반납중입니다.")
                                        
                                        //여기도 추후 이미지로 변경 예정
                                        location.text = "장소: 예약을 진행해 주세요."
                                        seatNum.text = "자리 번호: 예약을 진행해 주세요."
                                        reserveStartTime.text = "시작시간: 예약을 진행해 주세요."
                                        reserveEndTime.text = "종료 시간: 예약을 진행해 주세요."
                                        extend.isEnabled = false
                                        returned.isEnabled = false
                                        
                                        self.showToast(controller: self, message: "좌석이 반납되었습니다.")
                                    }
                                    else {
                                        print(getResult!)
                                        print("예약된 좌석이 없습니다.")
                                    }
                                }
                                
                            case .failure(_):
                                print("error")
                            }
                        }
                    }
                }
            case .failure(_):
                print("error")
            }
        }
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
