//
//  SelectSeat.swift
//  SwiftSample0129
//
//  Created by 구본의 on 2021/02/11.
//

import UIKit

class ReserveViewController: UIViewController {

    var showCurrentSeat: UILabel!
    
    var currentDay: UILabel!
    
    var startLb: UILabel!
    var startTime: UIDatePicker!
    var endLb: UILabel!
    var endTime: UIDatePicker!
    
    
    var completeBtn: UIButton!
    
    override func loadView() {
        super.loadView()
        
        
        
        showCurrentSeat = UILabel()
        showCurrentSeat.translatesAutoresizingMaskIntoConstraints = false
        showCurrentSeat.text = "서버에서 자리정보 불러올 예정"
        showCurrentSeat.backgroundColor = .gray
        self.view.addSubview(showCurrentSeat)
        
        
        
        currentDay = UILabel()
        currentDay.translatesAutoresizingMaskIntoConstraints = false
        currentDay.backgroundColor = .lightGray
        currentDay.textAlignment = .center
        let currentDayFomatter = DateFormatter()
        currentDayFomatter.locale = Locale(identifier: "ko")
        currentDayFomatter.dateFormat = "yyyy년 MM월 dd일 EEE요일"
        let currentDayText = currentDayFomatter.string(from: Date())
        currentDay.text = currentDayText
        self.view.addSubview(currentDay)
        
        startLb = UILabel()
        startLb.translatesAutoresizingMaskIntoConstraints = false
        startLb.text = "시작 시간"
        startLb.textAlignment = .center
        self.view.addSubview(startLb)
        
        startTime = UIDatePicker()
        startTime.translatesAutoresizingMaskIntoConstraints = false
        startTime.preferredDatePickerStyle = .wheels
        startTime.datePickerMode = .time
        //startTime.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
        startTime.minuteInterval = 15
        self.view.addSubview(startTime)
        
        endLb = UILabel()
        endLb.translatesAutoresizingMaskIntoConstraints = false
        endLb.text = "종료 시간"
        endLb.textAlignment = .center
        self.view.addSubview(endLb)
        
        endTime = UIDatePicker()
        endTime.translatesAutoresizingMaskIntoConstraints = false
        endTime.preferredDatePickerStyle = .wheels
        endTime.datePickerMode = .time
        endTime.minuteInterval = 15
        self.view.addSubview(endTime)
        
        completeBtn = UIButton(type: .system)
        completeBtn.translatesAutoresizingMaskIntoConstraints = false
        completeBtn.setTitle("예약하기", for: .normal)
        completeBtn.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        //completeBtn.addTarget(self, action: #selector(self.test(_:)), for: .touchUpInside)
        completeBtn.addTarget(self, action: #selector(self.test(_:)), for: .touchUpInside)
        self.view.addSubview(completeBtn)
        
        
        
        
        NSLayoutConstraint.activate([
            
            
            showCurrentSeat.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            showCurrentSeat.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showCurrentSeat.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            showCurrentSeat.heightAnchor.constraint(equalTo: showCurrentSeat.widthAnchor),
            
            currentDay.topAnchor.constraint(equalTo: showCurrentSeat.bottomAnchor, constant: 10),
            currentDay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentDay.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            currentDay.heightAnchor.constraint(equalTo: currentDay.widthAnchor, multiplier: 0.15),
            
            
                //최초 한결누나 디자인 따라감 / 아이폰 8에서 종료시간이 보이지 않는 레이아웃 오류 있음
            // startLb, endLb, startTime, endTime, completeBtn
            startLb.topAnchor.constraint(equalTo: currentDay.bottomAnchor),
            startLb.leadingAnchor.constraint(equalTo: currentDay.leadingAnchor),
            startLb.widthAnchor.constraint(equalTo: currentDay.widthAnchor, multiplier: 0.5),
            startLb.heightAnchor.constraint(equalTo: currentDay.heightAnchor, multiplier: 0.5),
            
            endLb.topAnchor.constraint(equalTo: currentDay.bottomAnchor),
            endLb.trailingAnchor.constraint(equalTo: currentDay.trailingAnchor),
            endLb.widthAnchor.constraint(equalTo: currentDay.widthAnchor, multiplier: 0.5),
            endLb.heightAnchor.constraint(equalTo: currentDay.heightAnchor, multiplier: 0.5),
            
            completeBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completeBtn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            completeBtn.widthAnchor.constraint(equalTo: currentDay.widthAnchor),
            completeBtn.heightAnchor.constraint(equalTo: currentDay.heightAnchor),
            
            startTime.topAnchor.constraint(equalTo: startLb.bottomAnchor),
            startTime.bottomAnchor.constraint(equalTo: completeBtn.topAnchor, constant: -10),
            startTime.leadingAnchor.constraint(equalTo: startLb.leadingAnchor),
            startTime.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            
            endTime.topAnchor.constraint(equalTo: endLb.bottomAnchor),
            endTime.bottomAnchor.constraint(equalTo: completeBtn.topAnchor, constant: -10),
            endTime.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            endTime.trailingAnchor.constraint(equalTo: endLb.trailingAnchor)
            
            
            
        ])
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
    }
    
    @objc func test(_ sender: UIButton) {
        btn(a: startTime, b: endTime)
        
      
       
    }
    
    func btn(a: UIDatePicker, b: UIDatePicker){
        let leftDatePickerView = a
        let rightDatePickerView = b
        
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH"
        let minFormatter = DateFormatter()
        minFormatter.dateFormat = "mm"
        
        
        let startHour = hourFormatter.string(from: leftDatePickerView.date)
        let startMin = minFormatter.string(from: leftDatePickerView.date)
        
        let endHour = hourFormatter.string(from: rightDatePickerView.date)
        let endMin = minFormatter.string(from: rightDatePickerView.date)
        
        let start = (Int(startHour)! * 60) + Int(startMin)!
        let end = (Int(endHour)! * 60) + Int(endMin)!
        let startk = (end - start) / 60
        let startkk = (end - start) % 60
        
        if (end - start) > 0 &&  (end - start) <= 240 {
            print("이용시간은 \(startHour)시 \(startMin)분 ~ \(endHour)시 \(endMin)분")
            let firstAlert = UIAlertController(title: "예약", message: "\(startHour)시 \(startMin)분 ~ \(endHour)시 \(endMin)분 \n 총 이용시간: \(startk)시간 \(startkk)분", preferredStyle: UIAlertController.Style.alert)
            let firstAlertActionNo = UIAlertAction(title: "수정", style: UIAlertAction.Style.default, handler: nil)
            let firstAlertActionOk = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in self.back()})
            
            firstAlert.addAction(firstAlertActionNo)
            firstAlert.addAction(firstAlertActionOk)
            present(firstAlert, animated: true, completion: nil)
            
        } else if (end - start) > 240 {
            print("최대 예약 시간은 4시간 입니다")
            let secondAlert = UIAlertController(title: "예약", message: "최대 예약 시간은 4시간 입니다", preferredStyle: UIAlertController.Style.alert)
            let secondAlertAction = UIAlertAction(title: "다시 설정하기", style: UIAlertAction.Style.default, handler: nil)
            secondAlert.addAction(secondAlertAction)
            present(secondAlert, animated: true, completion: nil)
            
        } else if (end - start) == 0 {
            print("최소 사용 시간은 15분 이상입니다")
            let thirdAlert = UIAlertController(title: "예약", message: "최소 사용 시간은 15분 이상입니다", preferredStyle: UIAlertController.Style.alert)
            let thirdAlertAction = UIAlertAction(title: "다시 설정하기", style: UIAlertAction.Style.default, handler: nil)
            thirdAlert.addAction(thirdAlertAction)
            present(thirdAlert, animated: true, completion: nil)
            
        } else {
            print("잘못된 시간 선택입니다")
            
            let fourthAlert = UIAlertController(title: "예약", message: "잘못된 시간 선택입니다", preferredStyle: UIAlertController.Style.alert)
            let fourthAlertAction = UIAlertAction(title: "다시 설정하기", style: UIAlertAction.Style.default, handler: nil)
            fourthAlert.addAction(fourthAlertAction)
            present(fourthAlert, animated: true, completion: nil)
        }
        
    }
    
    func back() {
        print("back")
        dismiss(animated: true, completion: nil)
    }
    
}
