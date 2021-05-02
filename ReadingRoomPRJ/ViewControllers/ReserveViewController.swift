
//
//  SelectSeat.swift
//  SwiftSample0129
//
//  Created by 구본의 on 2021/02/11.
//

import UIKit
import Alamofire
import PanModal

class ReserveViewController: UIViewController{

    var showCurrentSeat: UILabel!
    var currentDay: UILabel!
    var startLb: UILabel!
    var endLb: UILabel!
    
    var startTime: UIDatePicker!
    var endTime: UIDatePicker!
    
    var refreshBtn: UIButton!
    var completeBtn: UIButton!
    
    //셀 관련
    var cellTitle: UILabel!
    var cellImg: UIImageView!
    var cellBtn: UIButton!
    
    var rowCount:Int! // 가로 몇칸? -> it대학 기준 16
    var columnCount: Int!
    var totalCount:Int! // 전체 셀 개수. 2차원 배열 가로 * 세로
    var seatInfo: [Any] = []
    var seats = [Int:Int]()
  
    
    var selectedLeftTime: Int!
    var showLeftTime: Date!
    var selectedRightTime: Int!
    var showRightTime: Date!
    var nowTime: Int!
    
    var stateArr = Array(repeating: 0, count: Room.shared.totalCount)
    
    enum SeatType: Int {
        case Wall = -1
        case Empty = 0
        case Door = -2
        
    }
    
    
    //현재 좌석을 보여주는 컬렉션뷰 생성
    let showSeatCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func loadView() {
        super.loadView()
        navigationController?.navigationBar.tintColor = UIColor.rgbColor(r: 51, g: 51, b: 51)
        navigationItem.title = "좌석 예약"
        print("ReserveViewController의 loadView가 출력됩니다.")
        
        //컬렉션뷰 생성 라인
        self.view.addSubview(showSeatCollectionView)

        currentDay = UILabel()
        currentDay.translatesAutoresizingMaskIntoConstraints = false
        currentDay.backgroundColor = .white
        currentDay.textAlignment = .center
        let currentDayFomatter = DateFormatter()
        currentDayFomatter.locale = Locale(identifier: "ko")
        currentDayFomatter.dateFormat = "yyyy년 MM월 dd일 EEE요일"
        let currentDayText = currentDayFomatter.string(from: Date())
        currentDay.text = currentDayText
        currentDay.font = UIFont.boldSystemFont(ofSize: 15)
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
        startTime.minuteInterval = 10
        
        self.view.addSubview(startTime)
        
        endLb = UILabel()
        endLb.translatesAutoresizingMaskIntoConstraints = false
        endLb.text = "종료 시간"
        endLb.textAlignment = .center
        self.view.addSubview(endLb)
        
        endTime = UIDatePicker()
        
        //endTime.maximumDate = Calendar.current.date(byAdding: .min, value: 10, to: startTime.date)
        endTime.translatesAutoresizingMaskIntoConstraints = false
        endTime.preferredDatePickerStyle = .wheels
        endTime.datePickerMode = .time
        endTime.minuteInterval = 10
        self.view.addSubview(endTime)
        
        refreshBtn = UIButton(type: .system)
        refreshBtn.translatesAutoresizingMaskIntoConstraints = false
        refreshBtn.setTitle("재설정", for: .normal)
        refreshBtn.backgroundColor = UIColor.appColor(.mainColor)
        refreshBtn.tintColor = .white
        refreshBtn.layer.cornerRadius = 5
        refreshBtn.addTarget(self, action: #selector(self.clickReloadBtn(_:)), for: .touchUpInside)
        self.view.addSubview(refreshBtn)
        
        completeBtn = UIButton(type: .system)
        completeBtn.translatesAutoresizingMaskIntoConstraints = false
        completeBtn.setTitle("예약하기", for: .normal)
        completeBtn.tintColor = .white
        completeBtn.layer.cornerRadius = 5
        completeBtn.backgroundColor = UIColor.appColor(.mainColor)
        completeBtn.addTarget(self, action: #selector(self.reserveBtn(_:)), for: .touchUpInside)
        self.view.addSubview(completeBtn)
        
        let firstStackView = UIStackView()
        firstStackView.axis = .vertical
        firstStackView.alignment = .fill
        firstStackView.spacing = 0
        firstStackView.distribution = .fill
        
        let empty = UIImageView(frame: .zero)
        empty.contentMode = .scaleAspectFit
        let emptyImg = UIImage(named: "emptySeat.png")
        empty.image = emptyImg
        firstStackView.addArrangedSubview(empty)
        
        let notUse = UILabel()
        notUse.text = "빈좌석"
        notUse.textAlignment = .center
        notUse.contentMode = .scaleAspectFit
        firstStackView.addArrangedSubview(notUse)
        
        
        let secondStackView = UIStackView()
        secondStackView.axis = .vertical
        secondStackView.alignment = .fill
        secondStackView.distribution = .fill

        let ing = UIImageView(frame: .zero)
        ing.contentMode = .scaleAspectFit
        let ingImg = UIImage(named: "ingSeat.png")
        ing.image = ingImg
        secondStackView.addArrangedSubview(ing)

        let ingUse = UILabel()
        ingUse.text = "예약중"
        ingUse.textAlignment = .center
        ingUse.contentMode = .scaleAspectFit
        secondStackView.addArrangedSubview(ingUse)

        //====================

        let thirdStackView = UIStackView()
        thirdStackView.axis = .vertical
        thirdStackView.alignment = .fill
        thirdStackView.distribution = .fill

        let full = UIImageView(frame: .zero)
        full.contentMode = .scaleAspectFit
        let fullImg = UIImage(named: "fullSeat.png")
        full.image = fullImg
        thirdStackView.addArrangedSubview(full)

        let realUse = UILabel()
        realUse.text = "사용중"
        realUse.textAlignment = .center
        realUse.contentMode = .scaleAspectFit
        thirdStackView.addArrangedSubview(realUse)

        let totalStackView = UIStackView()
        totalStackView.axis = .horizontal
        totalStackView.spacing = 10
        totalStackView.alignment = .fill
        totalStackView.distribution = .fillProportionally
        
        totalStackView.addArrangedSubview(firstStackView)
        totalStackView.addArrangedSubview(secondStackView)
        totalStackView.addArrangedSubview(thirdStackView)
        
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(totalStackView)
        
        NSLayoutConstraint.activate([
            
            totalStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            totalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            totalStackView.heightAnchor.constraint(equalToConstant: 40),
            
            //컬렉션뷰 레이아웃 주기 / 추가 라인 96 ~ 100
            showSeatCollectionView.topAnchor.constraint(equalTo: totalStackView.bottomAnchor, constant: 5),  //컬렉션뷰 상단
            showSeatCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showSeatCollectionView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            showSeatCollectionView.heightAnchor.constraint(equalTo: showSeatCollectionView.widthAnchor, constant: -70),
            
            
            currentDay.topAnchor.constraint(equalTo: showSeatCollectionView.bottomAnchor, constant: 10),
            currentDay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentDay.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            currentDay.heightAnchor.constraint(equalTo: currentDay.widthAnchor, multiplier: 0.15),
            
            // startLb, endLb, startTime, endTime, completeBtn
            startLb.topAnchor.constraint(equalTo: currentDay.bottomAnchor, constant: 5),
            startLb.leadingAnchor.constraint(equalTo: currentDay.leadingAnchor),
            startLb.widthAnchor.constraint(equalTo: currentDay.widthAnchor, multiplier: 0.5),
            startLb.heightAnchor.constraint(equalTo: currentDay.heightAnchor, multiplier: 0.5),
            
            endLb.topAnchor.constraint(equalTo: currentDay.bottomAnchor, constant: 5),
            endLb.trailingAnchor.constraint(equalTo: currentDay.trailingAnchor),
            endLb.widthAnchor.constraint(equalTo: currentDay.widthAnchor, multiplier: 0.5),
            endLb.heightAnchor.constraint(equalTo: currentDay.heightAnchor, multiplier: 0.5),
            
            refreshBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            refreshBtn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            //refreshBtn.widthAnchor.constraint(equalTo: currentDay.widthAnchor),
            refreshBtn.leadingAnchor.constraint(equalTo: startLb.leadingAnchor),
            refreshBtn.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -5),
            refreshBtn.heightAnchor.constraint(equalTo: currentDay.heightAnchor),
            
            completeBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completeBtn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            completeBtn.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            completeBtn.trailingAnchor.constraint(equalTo: endLb.trailingAnchor),
            completeBtn.heightAnchor.constraint(equalTo: currentDay.heightAnchor),
            
            startTime.topAnchor.constraint(equalTo: startLb.bottomAnchor),
            startTime.bottomAnchor.constraint(equalTo: completeBtn.topAnchor, constant: -10),
            startTime.leadingAnchor.constraint(equalTo: startLb.leadingAnchor),
            startTime.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            
            endTime.topAnchor.constraint(equalTo: endLb.bottomAnchor),
            endTime.bottomAnchor.constraint(equalTo: completeBtn.topAnchor, constant: -10),
            endTime.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            endTime.trailingAnchor.constraint(equalTo: endLb.trailingAnchor),
            
        ])
        
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ReserveViewController의 viewDidLoad가 출력됩니다")
        view.backgroundColor = UIColor.appColor(.mainBackgroundColor)

        alertMaxTime()
        ReserveViewController().modalPresentationStyle = .fullScreen
        
        startTime.minimumDate = Date()
        endTime.minimumDate = Date()
        
        
        baseTimeRule()
        print("데이트피커 시간 표시 : \(startTime.date)")
        
        
        //  <-- 컬렉션뷰 --> //
        stateArr = Array(repeating: 0, count: Room.shared.totalCount)
        CollectionCell.countOne = 0
        
        //컬렉션뷰 delegate, datasource 호출 및 register주기
        showSeatCollectionView.dataSource = self
        showSeatCollectionView.delegate = self
        showSeatCollectionView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: CollectionCell.identifire)
        
    }
    
    
    
    func showToast(controller: UIViewController, message: String) {
        let width_variable = 10
        let toastLabel = UILabel(frame: CGRect(x: width_variable, y: Int(self.view.frame.size.height)-100, width: Int(view.frame.size.width)-2*width_variable, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.layer.cornerRadius = 15
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.clipsToBounds = true
        self.navigationController?.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0}, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
           })
        }
    
    
    @objc func addTargetDatePicker(_ sender: Any) {
        endTime.maximumDate = Calendar.current.date(byAdding: .hour, value: 4, to: startTime.date)
    }
    
    func alertMaxTime() {
        let alert = UIAlertController(title: "예약", message: "최대 예약 시간은 4시간 입니다", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.view.tintColor = UIColor.appColor(.textColor)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    
    func baseTimeRule() {
        let calendar = Calendar.current
        var startDateComponents = calendar.dateComponents([.month, .day, .year, .hour, .minute], from: startTime.date)
        guard var hour = startDateComponents.hour, var minute = startDateComponents.minute else {
            print("something went wrong")
            return
        }

        let intervalRemainder = minute % startTime.minuteInterval
        if intervalRemainder > 0 {
            // need to correct the date
            minute += startTime.minuteInterval - intervalRemainder
            if minute >= 60 {
                hour += 1
                minute -= 60
            }

            // update datecomponents
            startDateComponents.hour = hour
            startDateComponents.minute = minute
            
            // get the corrected date
            guard let roundedDate = calendar.date(from: startDateComponents) else {
                print("something went wrong")
                return
            }

            // update the datepicker
            startTime.date = roundedDate
        }
        
        //종류 데이트피커를 시작시간 +2시간으로 세팅
        var endDateComponents = calendar.dateComponents([.month, .day, .year, .hour, .minute], from: endTime.date)
        guard var endHour = endDateComponents.hour else {
            print("www")
            return
        }

        if startDateComponents.hour == 21 {
            endHour = startDateComponents.hour! + 2
        } else if startDateComponents.hour == 22 {
            endHour = startDateComponents.hour! + 1
        } else if startDateComponents.hour == 23 {
            endHour = startDateComponents.hour!
        
            
        } else {
            endHour = startDateComponents.hour! + 3
        }
        
        endDateComponents.hour = endHour
        endDateComponents.day = startDateComponents.day
        endDateComponents.minute = startDateComponents.minute
        guard let addHour = calendar.date(from: endDateComponents) else {
            print("wwwwww")
            return
        }
        
        endTime.date = addHour
        startTime.addTarget(self, action: #selector(addTargetDatePicker), for: .allEvents)
    }
    
    
    @objc func clickReloadBtn(_ sender: Any){
        
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH"
        let minFormatter = DateFormatter()
        minFormatter.dateFormat = "mm"
        
        
        if startTime.date > endTime.date {
            let alert = UIAlertController(title: "경고", message: "종료 시간이 시작 시간보다 늦으야 합니다.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
            
        } else {
            let startHour = hourFormatter.string(from: startTime.date)
            let startMin = minFormatter.string(from: startTime.date)
            
            let endHour = hourFormatter.string(from: endTime.date)
            let endMin = minFormatter.string(from: endTime.date)
            
            let reFreshAlert = UIAlertController(title: "재설정", message: "\(startHour)시 \(startMin)분 ~ \(endHour)시 \(endMin)분 \n 좌석을 보시겠나요?", preferredStyle: UIAlertController.Style.alert)
            let reFreshAlertNo = UIAlertAction(title: "수정", style: UIAlertAction.Style.default, handler: nil)
            //let reFreshAlertYes = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
            let reFreshAlertYes = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in self.collectionViewReload()})
            
            reFreshAlert.addAction(reFreshAlertNo)
            reFreshAlert.addAction(reFreshAlertYes)
            reFreshAlert.view.tintColor = UIColor.appColor(.textColor)
            present(reFreshAlert, animated: true, completion: nil)
        }
        
    }
    
    
    func collectionViewReload() {
        showSeatCollectionView.reloadData()     //* 한줄 추가시에 데이터 리로드 성공!
        CollectionCell.userSelectedSeat = ""
        CollectionCell.userSeatInfo = -1
        CollectionCell.checkArr = ReserveViewController().stateArr
           
    }
    
    
    @objc func reserveBtn(_ sender: UIButton) {
        // if 선택한 좌석X -> 좌석선택부터 해주세요 alert, else
        if CollectionCell.userSelectedSeat == "" {
            let emptySeatAlert = UIAlertController(title: "예약", message: "좌석을 먼저 선택해 주세요!", preferredStyle: UIAlertController.Style.alert)
            let emptySeatOK = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
            emptySeatAlert.addAction(emptySeatOK)
            present(emptySeatAlert, animated: true, completion: nil)
        }
        
        btnDatePicker(firstDatePicker: startTime, secondDatePicker: endTime)
    }
    
    func btnDatePicker(firstDatePicker: UIDatePicker, secondDatePicker: UIDatePicker){
        let leftDatePickerView = firstDatePicker
        let rightDatePickerView = secondDatePicker
        
        let currentDayFomatter = DateFormatter()
        currentDayFomatter.dateFormat = "yyyy-MM-dd HH:mm"
        currentDayFomatter.locale = Locale(identifier: "ko_kr")
        currentDayFomatter.timeZone = TimeZone(abbreviation: "KST")

        
        //시작시간 데이트 피커에 해당하는 시간 값 & 유저디폴트 삭제를 위해서 전역변수로 선언한 값들 존재(selectedLeftTime,showLeftTime)
        let selectedLeftDateString = currentDayFomatter.string(from: firstDatePicker.date)
        let selectedLeftDateChange: Date = currentDayFomatter.date(from: selectedLeftDateString)!
        selectedLeftTime = Int(selectedLeftDateChange.timeIntervalSince1970) * 1000    //서버로 보내는 long값
        showLeftTime = Date(timeIntervalSince1970: TimeInterval(selectedLeftTime) / 1000)   //보여지는 날짜 및 시간 값
        
       
        //종료시간 데이트 피커에 해당하는 시간 값 & 유저디폴트 삭제를 위해서 전역변수로 선언한 값들 존재(selectedRightTime,showRightTime)
        let selectedRightDateString = currentDayFomatter.string(from: secondDatePicker.date)
        let selectedRightDateChange: Date = currentDayFomatter.date(from: selectedRightDateString)!
        selectedRightTime = Int(selectedRightDateChange.timeIntervalSince1970) * 1000     //서버로 보내는 long값
        showRightTime = Date(timeIntervalSince1970: TimeInterval(selectedRightTime) / 1000)   //보여지는 날짜 및 시간 값
    
        //현재 시간을 서버로 보내기 위해서 nowTime 전역 변수로 설정
        let startTimeString = currentDayFomatter.string(from: Date())
        let startTimeDate:Date = currentDayFomatter.date(from: startTimeString)!
        nowTime = Int(startTimeDate.timeIntervalSince1970) * 1000
       
        // <------ Alert에 보여주기 위해서 단순히 숫자값만을 계산하기 위한 시간값들 설정------->
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
        let totalHour = (end - start) / 60
        let totalMin = (end - start) % 60
        
        
        
        if(Int(nowTime) > Int(selectedLeftTime)) {
            print("현재 시간 이후로 예약이 가능합니다.")
            let thirdAlert = UIAlertController(title: "예약", message: "현재 시간 이후로 예약 가능합니다.", preferredStyle: UIAlertController.Style.alert)
            let thirdAlertAction = UIAlertAction(title: "다시 설정하기", style: UIAlertAction.Style.default, handler: nil)
            thirdAlert.view.tintColor = UIColor.appColor(.textColor)
            thirdAlert.addAction(thirdAlertAction)
            present(thirdAlert, animated: true, completion: nil)
        }
        else {
            if (selectedRightTime - selectedLeftTime) >= 600000 &&  (selectedRightTime - selectedLeftTime) <= 14400000 {
                print("이용시간은 \(startHour)시 \(startMin)분 ~ \(endHour)시 \(endMin)분")
                print("begin: \(selectedLeftTime!)")
                print(showLeftTime as Any)
                print("end: \(selectedRightTime!)")
                print(showRightTime as Any)
            
                let firstAlert = UIAlertController(title: "예약", message: "\(CollectionCell.userSelectedSeat)번 \n \(startHour)시 \(startMin)분 ~ \(endHour)시 \(endMin)분 \n 총 이용시간: \(totalHour)시간 \(totalMin)분", preferredStyle: UIAlertController.Style.alert)
                let firstAlertActionNo = UIAlertAction(title: "수정", style: UIAlertAction.Style.default, handler: nil)
                let firstAlertActionOk = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in self.confirmReserve()})
                
                firstAlert.addAction(firstAlertActionNo)
                firstAlert.addAction(firstAlertActionOk)
                firstAlert.view.tintColor = UIColor.appColor(.textColor)
                
                present(firstAlert, animated: true, completion: nil)
            } else if (selectedRightTime - selectedLeftTime) > 14400000 {
                
                let secondAlert = UIAlertController(title: "예약", message: "최대 예약 시간은 4시간 입니다", preferredStyle: UIAlertController.Style.alert)
                let secondAlertAction = UIAlertAction(title: "다시 설정하기", style: UIAlertAction.Style.default, handler: nil)
                secondAlert.view.tintColor = UIColor.appColor(.textColor)
                secondAlert.addAction(secondAlertAction)
                present(secondAlert, animated: true, completion: nil)
                
            }
            else {
                print("잘못된 시간 선택입니다")
                
                let fourthAlert = UIAlertController(title: "예약", message: "잘못된 시간 선택입니다", preferredStyle: UIAlertController.Style.alert)
                let fourthAlertAction = UIAlertAction(title: "다시 설정하기", style: UIAlertAction.Style.default, handler: nil)
                fourthAlert.view.tintColor = UIColor.appColor(.textColor)
                fourthAlert.addAction(fourthAlertAction)
                present(fourthAlert, animated: true, completion: nil)
            }
        }
        
    }
    
    func confirmReserve() {
        print("back")
        
        
        let accountInfo = UserDefaults.standard.dictionary(forKey: "accountInfo")! as Dictionary
        let studentInfo = UserDefaults.standard.dictionary(forKey: "studentInfo")! as Dictionary
        
        print("총 이용시간 Long 값 계산")
        print(selectedRightTime! - selectedLeftTime)
        print(nowTime)
        
        let seat: Int = Int(CollectionCell.userSelectedSeat)!
        let time: Int = nowTime
        print(accountInfo["pw"]!)
        print(time)
        let param = [
            "id": accountInfo["id"] as! String,
            "password": accountInfo["pw"] as! String,
            "studentId": studentInfo["studentId"] as! String,
            "end": selectedRightTime!,
            "begin": selectedLeftTime!,
            "time": nowTime!,
            "seat": seat,
            "roomName": Room.shared.name!,
            "college": studentInfo["college"] as! String        //IT
        ] as [String : Any]
        
        print(Room.shared.name!)
        RequestAPI.post(resource: "/room/reserve", param: param, responseData: "reservation", completion: {(result, response) in
            if (result) {
                
                UserDefaults.standard.set(self.selectedLeftTime, forKey: "baseUserBeginTime")
                UserDefaults.standard.set(self.selectedRightTime, forKey: "baseUserEndTime")
                
                //let reservation = response as! NSDictionary
                print("좌석 예약 완료")
                self.showToast(controller: self, message: "예약되었습니다. n분 내로 자리를 확정해 주세요.")    //문구 수정 필요
                self.navigationController?.popViewController(animated: true)
                
            } else {
                
                print("예약 실패")
                print(studentInfo)
                print()
                print("result:: \(result)")
                
                self.showToast(controller: self, message: "이미 예약이 되어있거나 잘못된 시간 설정입니다")    //문구 수정 필요
                //어떤 오류인지 확인이 가능한지..? 서버쪽 에러 메세지 확인 후 분기 처리하면 될 듯
            }
        })
        
    }
}




//컬렉션 뷰 확장 관련 코드        / 234~ end
extension ReserveViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("totalCount가 리턴되는 extension이 호출됩니다.")
        return Room.shared.totalCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifire, for: indexPath) as! CollectionCell
        UserDefaults.standard.set(indexPath[1], forKey: "indexPath")
                
        let columnNumber:Int = ((indexPath[1]) / Room.shared.columnCount)
        UserDefaults.standard.set(columnNumber, forKey: "columnNumber")
        
        let arrayT: [Any] = Room.shared.seat![columnNumber] as! [Any]
        UserDefaults.standard.set(arrayT, forKey: "arrayT")
        
        let curr:Int = arrayT[indexPath[1]%Room.shared.columnCount] as! Int
        UserDefaults.standard.set(curr, forKey: "curr")
       
        func cellState() {
            cell.myImageView.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.width)

            cell.myButton.setTitle(String(curr), for: .normal)
            cell.myButton.tintColor = .black
            cell.myButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 7)
            cell.myButton.addTarget(self, action: #selector(self.tapBtn(_:)), for: .touchUpInside)
            cell.myButton.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.width)
            cell.myButton.isEnabled = true
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
        }
        
        
        switch curr{
        case SeatType.Wall.rawValue:
            cell.myImageView.image = UIImage(named: "road.png")
            cell.myImageView.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.width)
            break

        case SeatType.Door.rawValue:
            cell.myImageView.image = UIImage(named: "door.jpeg")
            cell.myImageView.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.width)
            break

        case SeatType.Empty.rawValue:
            cell.myImageView.image = UIImage(named: "road.png")
            cell.myImageView.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width*0.8, height: cell.bounds.size.width)
            break

        default:
            let college: String = String(utf8String: UserDefaults.standard.dictionary(forKey: "studentInfo")!["college"] as! String)! //2층
            let param = ["college": college] as [String : Any]
            
            RequestAPI.post(resource: "/rooms", param: param, responseData: "rooms", completion: {(result, response) in
                if (result) {
                    let reserveInfo = ((response as! NSArray)[0] as! NSDictionary)["reserved"] as! NSArray
                    if (reserveInfo[curr] as AnyObject).count == 0 {
                        cell.myImageView.image = UIImage(named: "emptySeat.png")
                        cellState()
                    } else {
                        let selectedStartTime = self.startTime.date
                        let userStartTime = Int(selectedStartTime.timeIntervalSince1970) * 1000    //서버로 보내는 long값
                   
                        let selectedEndTime = self.endTime.date
                        let userEndTime = Int(selectedEndTime.timeIntervalSince1970) * 1000    //서버로 보내는 long값
                    
                        let seatReserveInfo = reserveInfo[curr] as! NSArray
                        for currNum in 0..<seatReserveInfo.count {
                            print("i:::: \(currNum)")
                            let currSeatInfo = seatReserveInfo[currNum] as! NSDictionary
                            let begin = currSeatInfo["begin"] as! Int    //예약된 좌석의 시작시간
                            let end = currSeatInfo["end"] as! Int        //예약된 좌석의 종료시간
                                                    
                                                    
                            if userStartTime < end && userEndTime > begin {
                                if currSeatInfo["confirmed"] as! Int == 0 {
                                    cell.myImageView.image = UIImage(named: "ingSeat.png")
                                    cellState()
                                    break
                                    }
                                else {
                                        cell.myImageView.image = UIImage(named: "fullSeat.png")
                                        cellState()
                                        break
                                        }
                                }
                            else {
                                    cell.myImageView.image = UIImage(named: "emptySeat.png")
                                    cellState()

                                }
                            }
                        }
                    }
                })
            }
        cell.viewController = self
        return cell
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.showSeatCollectionView)
        let indexPath = self.showSeatCollectionView.indexPathForItem(at: location)
        if let index = indexPath {
            print("Got clicked on index: \(index[1])!")
        }
    }
                //좌석 클릭시 선택 좌석을 알려주는 알림창 함수였는데 취소를 눌러서 다시 원래 색상으로 변경을 시킨다면 그때 다시 사용할 예정. 현재는 이미지 변경으로 처리해 놓음.
    @objc func tapBtn(_ sender: UIButton){
        
    }
    
}


extension ReserveViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        print(seats[indexPath.item] as Any)
        print("좌석 클릭시에 값 보여주는 extentionDelegate")
    }
}

extension ReserveViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt seection: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //return 1
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (Int(collectionView.frame.width)) / (Room.shared.columnCount ) ///  3등분하여 배치, 옆 간격이 1이므로 1을 빼줌
        let size = CGSize(width: width, height: width) //이렇게 주게 되면 한줄에 4개씩 보여지게 됌 240번 줄 return 16으로 수정하면 확인 가능
        return size
    }
    
}
