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
    
    var mySeat:             UILabel!
    var location:           UILabel!
    var seatNum:            UILabel!
    var reserveStartTime:   UILabel!
    var reserveEndTime:     UILabel!
    
    var extend:             UIButton!
    var returned:           UIButton!
    
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large) //서버 통신 대기를 위한 스피너 생성

    override func loadView() {
        print("로드뷰 출력")
        super.loadView()

        view = UIView()
        view.backgroundColor = UIColor.appColor(.mainBackgroundColor)

        //스피너 생성 코드
        spinner.translatesAutoresizingMaskIntoConstraints = false
        //spinner.startAnimating()
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        
        mySeat = UILabel()
        mySeat.translatesAutoresizingMaskIntoConstraints = false
        mySeat.textAlignment = .center
        mySeat.text = "나의 자리"
        mySeat.font = UIFont.systemFont(ofSize: 30)
        mySeat.textColor = .black
        view.addSubview(mySeat)

        location = UILabel()
        location.translatesAutoresizingMaskIntoConstraints = false
        location.text = "장소: \(MainViewController.college) \(MainViewController.room) "
        location.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(location)

        seatNum = UILabel()
        seatNum.translatesAutoresizingMaskIntoConstraints = false
        seatNum.text = "자리 번호: \(MainViewController.seat)"
        seatNum.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(seatNum)

        reserveStartTime = UILabel()
        reserveStartTime.translatesAutoresizingMaskIntoConstraints = false
        reserveStartTime.text = totalUseTime()
        reserveStartTime.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(reserveStartTime)

        extend = UIButton(type: .system)
        extend.translatesAutoresizingMaskIntoConstraints = false
        extend.setTitle("연장", for: .normal)
        extend.backgroundColor = UIColor.appColor(.mainColor)
        extend.tintColor = .white
        extend.layer.cornerRadius = 5
        extend.addTarget(self, action: #selector(self.extendDatePicker(_:)), for: .touchUpInside)
        extend.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        possibleExtendInView()
        view.addSubview(extend)
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "자리확정"
    }

    // 뷰 내용
    func totalUseTime() -> String{
        let beginTime = MainViewController.userBeginTime
        let endTime = MainViewController.userEndTime
        let beginTimeInterval = (TimeInterval(beginTime)) / 1000
        let endTimeInterval = (TimeInterval(endTime)) / 1000
        let insertBeginTime = Date(timeIntervalSince1970: beginTimeInterval)    //long값으로 된 시간값을 바꿔줌
        let insertEndTime = Date(timeIntervalSince1970: endTimeInterval)

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH시 mm분"
        let finalStart = timeFormatter.string(from: insertBeginTime)
        let finalEnd = timeFormatter.string(from: insertEndTime)
        
        return "이용시간: \(finalStart) ~ \(finalEnd)"
    }
    
    
    func possibleExtendInView() {
        let userUsingTime = UserDefaults.standard.integer(forKey: "baseUserEndTime") - UserDefaults.standard.integer(forKey: "baseUserBeginTime")
        let userPossibleExtendTime = UserDefaults.standard.integer(forKey: "baseUserEndTime") - (userUsingTime / 2)
        print("이용시간 : \(userUsingTime)")
        print("연장이 가능한 시간 : \(userPossibleExtendTime)")

        //현재 시간과의 비교를 위해 현재 시간을 long값으로 변경해줌
        let currTime = Int(Date().timeIntervalSince1970) * 1000 //현재시간 long값

        if currTime >= userPossibleExtendTime {
            print("연장 가능")
        } else {
            print("연장 불가능")
        }

        if MainViewController.confirmed && currTime >= userPossibleExtendTime {
            extend.isEnabled = true

        } else {
            extend.isEnabled = false
        }
    }
    
    //반납
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
        //spinner.startAnimating()

        let accountInfo = UserDefaults.standard.dictionary(forKey: "accountInfo")! as NSDictionary
        let id = accountInfo["id"] as! String
        let password = accountInfo["pw"] as! String

        let param = [
            "id": id,
            "password": password,
            "college": MainViewController.college,
            "roomName": MainViewController.room,
            "reservationId": MainViewController.reserveID
        ] as [String : Any]

        RequestAPI.post(resource: "/room/reserve/cancel", param: param, responseData: "reservation", completion: {(result, response) in
            if result {
                print("성공")
                print(response)
                //self.spinner.stopAnimating()
                Toast.showToast(vc: self.presentingViewController!, message: "좌석 반납이 완료되었습니다.")
                self.dismiss(animated: true, completion: nil)
            } else {
                print("실패")
                print(response)
                //self.spinner.stopAnimating()
            }
        })

    }
    
    //연장
    @objc func extendDatePicker(_ sender: Any) {
        let myDatePicker: UIDatePicker = UIDatePicker()
        myDatePicker.preferredDatePickerStyle = .wheels
        myDatePicker.datePickerMode = .time
        myDatePicker.minuteInterval = 5
        //myDatePicker.frame = CGRect(x: 0, y: 35, width: 270, height: 200)
        myDatePicker.frame = CGRect(x: 0, y: 35, width: 270, height: 200)


        let userEndTime = TimeInterval(MainViewController.userEndTime) / 1000
        let minExtendTime = Date(timeIntervalSince1970: userEndTime)
        print("변환된 시간 값:::::::::::: \(minExtendTime)")


        myDatePicker.minimumDate = minExtendTime
        myDatePicker.maximumDate = Calendar.current.date(byAdding: .minute, value: 240, to: minExtendTime)


        let alertController = UIAlertController(title: "연장 시간\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)


        alertController.view.addSubview(myDatePicker)

        let selectAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.userSelectedExtendTime(extendTime: myDatePicker)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)


    }




    func userSelectedExtendTime(extendTime: UIDatePicker) {
        
        let extendDateFormatter = DateFormatter()
        extendDateFormatter.dateFormat = "yyyy-MM-dd HH시 mm분"
        extendDateFormatter.locale = Locale(identifier: "ko_kr")
        extendDateFormatter.timeZone = TimeZone(abbreviation: "KST")

        //시작시간 데이트 피커에 해당하는 시간 값 & 유저디폴트 삭제를 위해서 전역변수로 선언한 값들 존재(selectedLeftTime,showLeftTime)
        let extendTimeString = extendDateFormatter.string(from: extendTime.date)
        let extendTimeChange: Date = extendDateFormatter.date(from: extendTimeString)!
        let extendLongTime: Int = Int(extendTimeChange.timeIntervalSince1970) * 1000

        print(extendTimeString) //피커값 그대로 보여줌
        print(extendTimeChange)
        print(extendLongTime)
        
        let baseEndTime = TimeInterval(MainViewController.userEndTime) / 1000
        let baseEndTimeDate = Date(timeIntervalSince1970: baseEndTime)
        let oldEndTime = extendDateFormatter.string(from: baseEndTimeDate)
        print("변환된 시간 값:::::::::::: \(baseEndTimeDate)")


        MainViewController.newEndTime = extendLongTime    //연장 시 서버로 보내지는 값
        let alertController = UIAlertController(title: "연장시간", message: "기존: \(oldEndTime)\n변경: \(extendTimeString)\n연장하시겠어요?", preferredStyle: UIAlertController.Style.alert)
        let selectAction = UIAlertAction(title: "Ok", style: .default, handler:{ _ in
            self.openExtendQR()
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)

    }

    func openExtendQR() {
        present(ExtendQRScanViewController(), animated: true, completion: nil)
    }

    func dismissMySeatView() {
        self.dismiss(animated: true, completion: nil)
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
