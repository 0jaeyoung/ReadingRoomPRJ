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
    var spinner = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("디드 로드뷰")
        self.title = "자리확정"
        
        
        
        
        //self.navigationController?.isNavigationBarHidden = false
        //self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
    
    
   
    override func loadView() {
        print("로드뷰 출력")
        super.loadView()
        view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        
        
        
        self.myInfo()
        
        
//        mySeat = UILabel()
//        mySeat.translatesAutoresizingMaskIntoConstraints = false
//        mySeat.textAlignment = .center
//        mySeat.text = "나의 자리"
//        mySeat.font = UIFont.systemFont(ofSize: 30)
//        mySeat.textColor = .black
//        mySeat.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
//        view.addSubview(mySeat)
//
//        location = UILabel()
//        location.translatesAutoresizingMaskIntoConstraints = false
//        location.text = "장소: " + UserDefaults.standard.string(forKey: "mySeatPlace")!
//        //location.text = "장소: "
//        location.font = UIFont.systemFont(ofSize: 20)
//        view.addSubview(location)
//
//        seatNum = UILabel()
//        seatNum.translatesAutoresizingMaskIntoConstraints = false
//        seatNum.text = "자리 번호: \(UserDefaults.standard.integer(forKey: "selectedSeatNumber"))"
//        //seatNum.text = "자리 번호: "
//        seatNum.font = UIFont.systemFont(ofSize: 20)
//        view.addSubview(seatNum)
//
//        reserveTime = UILabel()
//        reserveTime.translatesAutoresizingMaskIntoConstraints = false
//        reserveTime.text = "예약 시간: " +  UserDefaults.standard.string(forKey: "startTimeString")! + "~" + UserDefaults.standard.string(forKey: "endTimeString")!
//        //reserveTime.text = "예약 시간: "
//        reserveTime.font = UIFont.systemFont(ofSize: 20)
//        view.addSubview(reserveTime)
//
//        let extend = UIButton(type: .system)
//        extend.translatesAutoresizingMaskIntoConstraints = false
//        extend.setTitle("연장", for: .normal)
//        extend.addTarget(self, action: #selector(self.clickExtend(_:)), for: .touchUpInside)
//        extend.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
//        extend.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
//        view.addSubview(extend)
//
//
//        let returned = UIButton(type: .system)
//        returned.translatesAutoresizingMaskIntoConstraints = false
//        returned.setTitle("반납", for: .normal)
//        returned.addTarget(self, action: #selector(self.clickReturn(_:)), for: .touchUpInside)
//        returned.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
//        returned.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
//        view.addSubview(returned)
//
//
//        NSLayoutConstraint.activate([
//            mySeat.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            mySeat.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
//            mySeat.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
//
//            location.topAnchor.constraint(equalTo: mySeat.bottomAnchor, constant: 25),
//            location.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
//
//            seatNum.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 10),
//            seatNum.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
//
//            reserveTime.topAnchor.constraint(equalTo: seatNum.bottomAnchor, constant: 10),
//            reserveTime.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
//
//            extend.topAnchor.constraint(equalTo: reserveTime.bottomAnchor, constant: 20),
//            extend.trailingAnchor.constraint(equalTo: view.centerXAnchor),
//            extend.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4),
//            extend.heightAnchor.constraint(equalToConstant: 45),
//
//            returned.topAnchor.constraint(equalTo: reserveTime.bottomAnchor, constant: 20),
//            returned.leadingAnchor.constraint(equalTo: view.centerXAnchor),
//            returned.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4),
//            returned.heightAnchor.constraint(equalToConstant: 45)
//
//        ])
//
//
//
//
        
        
    }
    
    
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
                    //let getMessage: String? = jsonObj.object(forKey: "message") as? String
                    print("getresult :: \(getResult!)")
                    if getResult! {
                        let mySeatInfo: NSArray = jsonObj.object(forKey: "reservations") as! NSArray
                        print(getResult!)
                        
                        print(mySeatInfo)
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
                            //location.text = "장소: "
                            location.font = UIFont.systemFont(ofSize: 20)
                            view.addSubview(location)
                            
                            seatNum = UILabel()
                            seatNum.translatesAutoresizingMaskIntoConstraints = false
                            seatNum.text = "자리 번호: 예약을 진행해 주세요."
                            //seatNum.text = "자리 번호: "
                            seatNum.font = UIFont.systemFont(ofSize: 20)
                            view.addSubview(seatNum)
                            
                            reserveStartTime = UILabel()
                            reserveStartTime.translatesAutoresizingMaskIntoConstraints = false
                            reserveStartTime.text = "시작 시간: " + "예약을 진행해 주세요."
                            reserveStartTime.textAlignment = .right
                            reserveStartTime.font = UIFont.systemFont(ofSize: 20)
                            view.addSubview(reserveStartTime)
                            
                            
                            reserveEndTime = UILabel()
                            reserveEndTime.translatesAutoresizingMaskIntoConstraints = false
                            reserveEndTime.text = "종료 시간: " + "예약을 진행해 주세요."
                            reserveEndTime.textAlignment = .right
                            reserveEndTime.font = UIFont.systemFont(ofSize: 20)
                            view.addSubview(reserveEndTime)
//
                            
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
                                
                                
                            ])
                            
                            
                        } else {
                            let length = mySeatInfo.count
                            let userCurrentInfo = mySeatInfo[length - 1] as! Dictionary<String, Any>
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
                            //location.text = "장소: "
                            location.font = UIFont.systemFont(ofSize: 20)
                            view.addSubview(location)
                            
                            seatNum = UILabel()
                            seatNum.translatesAutoresizingMaskIntoConstraints = false
                            seatNum.text = "자리 번호: \((userCurrentInfo["seat"]!))"
                            //seatNum.text = "자리 번호: "
                            seatNum.font = UIFont.systemFont(ofSize: 20)
                            view.addSubview(seatNum)
                            
                            
                            let beginTime = userCurrentInfo["begin"] as! Int
                            let endTime = userCurrentInfo["end"] as! Int
                            let beginTimeInterval = TimeInterval(beginTime + 32400000) / 1000
                            let endTimeInterval = TimeInterval(endTime + 32400000) / 1000
                            let insertBeginTime = Date(timeIntervalSince1970: beginTimeInterval)
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
                            
                            let extend = UIButton(type: .system)
                            extend.translatesAutoresizingMaskIntoConstraints = false
                            extend.setTitle("연장", for: .normal)
                            extend.addTarget(self, action: #selector(self.clickExtend(_:)), for: .touchUpInside)
                            extend.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
                            extend.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
                            view.addSubview(extend)
                            
                            
                            let returned = UIButton(type: .system)
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
    
    
    
    
    
    
   
    
    @objc func clickExtend(_ sender: Any) {
        print("연장 버튼 클릭")
        let extend = UIAlertController(title: "연장", message: "얼마나 더 공부하실 껀가요?", preferredStyle: UIAlertController.Style.alert)
        let first = UIAlertAction(title: "30분", style: UIAlertAction.Style.default, handler: nil)
        let second = UIAlertAction(title: "60분", style: UIAlertAction.Style.default, handler: nil)
        let third = UIAlertAction(title: "90분", style: UIAlertAction.Style.default, handler: nil)
        let fourth = UIAlertAction(title: "120분", style: UIAlertAction.Style.default, handler: nil)
        let cancel = UIAlertAction(title: "취소", style: UIAlertAction.Style.destructive, handler: nil)
        extend.addAction(first)
        extend.addAction(second)
        extend.addAction(third)
        extend.addAction(fourth)
        extend.addAction(cancel)
        
        present(extend, animated: true, completion: nil)
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
    
    

    
    
    func seatReturn() {
        print("반납 버튼이 눌렸습니다.")
        spinner.startAnimating()
        let studentId: String = UserDefaults.standard.dictionary(forKey: "studentInfo")?["studentId"]! as! String
        let college: String = "TEST"
        let room: String = "Test"
        let seat: Int = UserDefaults.standard.integer(forKey: "selectedSeatNumber")
        let time: Int = UserDefaults.standard.integer(forKey: "nowTime")
        let begin: Int = UserDefaults.standard.integer(forKey: "userStartTime")
        let end: Int = UserDefaults.standard.integer(forKey: "userEndTime")
        let ID: String = UserDefaults.standard.dictionary(forKey: "studentInfo")?["id"]! as! String
        let PW: String = UserDefaults.standard.dictionary(forKey: "studentInfo")?["password"]! as! String



//        let studentId: String = "201736038"
//        let college: String = "TEST"
//        let room: String = "Test"
//        let seat: Int = 2
//        let time: Int = 1616140988000
//        let begin: Int = 1616148055000
//        let end: Int = 1616151655000
//        let ID: String = "ownerchef2"
//        let PW: String = "owner9809~"

//

        let reservedURL = "http://3.34.174.56:8080/room/cancel"
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
        
        let alamo = AF.request(reservedURL, method: .post, parameters: PARAM).validate(statusCode: 200..<450)
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
                        print("좌석을 취소취소취소")
                        
                        
                        location.text = "장소: 예약을 진행해 주세요."
                        seatNum.text = "자리 번호: 예약을 진행해 주세요."
                        reserveStartTime.text = "시작시간: 예약을 진행해 주세요."
                        reserveEndTime.text = "종료 시간: 예약을 진행해 주세요."
                        
                        
                        
                        
                        self.showToast(controller: self, message: "좌석이 반납되었습니다.")
                 
                    
                    }
                    else {
                        print(getResult!)
                        
                        print("예약된 좌석이 없습니다.취소취소를 출력하지 못합니다.")
                    }
                    
                }
                
            case .failure(_):
                print("error")
            }
            
            
            }
            
        
    }
    
    func showToast(controller: UIViewController, message: String) {
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
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
                        toastLabel.alpha = 0.0}
                       , completion: {(isCompleted) in
                                       toastLabel.removeFromSuperview()
                       })
        
        /*
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .lightGray
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
            self.navigationController?.popViewController(animated: true)
        }
        */
    }
    
    
    
}


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


