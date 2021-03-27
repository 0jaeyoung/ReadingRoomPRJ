//
//  SelectSeat.swift
//  SwiftSample0129
//
//  Created by 구본의 on 2021/02/11.
//

import UIKit
import Alamofire

class ReserveViewController: UIViewController {

    var showCurrentSeat: UILabel!
    var currentDay: UILabel!
    var startLb: UILabel!
    var startTime: UIDatePicker!
    var endLb: UILabel!
    var endTime: UIDatePicker!
    var refreshBtn: UIButton!
    var completeBtn: UIButton!
    
    var rowCount:Int! // 가로 몇칸? -> it대학 기준 16
    var columnCount: Int!
    var totalCount:Int! // 전체 셀 개수. 2차원 배열 가로 * 세로
    var seatInfo: [Any] = []
    var seats = [Int:Int]()
  
    var cellTitle: UILabel!
    var cellImg: UIImageView!
    var cellBtn: UIButton!
    
    
    
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
    
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    override func loadView() {
        super.loadView()
        
        print("ReserveViewController의 loadView가 출력됩니다.")
        
        //컬렉션뷰 줌 사용하기 위해서 테스트 중인 코드
//        self.navigationController?.navigationBar.topItem?.title = ""
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//
//        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(self.scrollView)
//        self.scrollView.addSubview(self.stackView)
//        self.stackView.translatesAutoresizingMaskIntoConstraints = false
//        self.stackView.axis = .vertical
//        self.stackView.spacing = 1
//
//        self.stackView.addArrangedSubview(showSeatCollectionView)


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
        endTime.translatesAutoresizingMaskIntoConstraints = false
        endTime.preferredDatePickerStyle = .wheels
        endTime.datePickerMode = .time
        endTime.minuteInterval = 10
        self.view.addSubview(endTime)
        
        
        
        
        refreshBtn = UIButton(type: .system)
        refreshBtn.translatesAutoresizingMaskIntoConstraints = false
        refreshBtn.setTitle("재설정", for: .normal)
        refreshBtn.backgroundColor = .purple
        refreshBtn.tintColor = .black
        //refreshBtn.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
        self.view.addSubview(refreshBtn)
        
        completeBtn = UIButton(type: .system)
        completeBtn.translatesAutoresizingMaskIntoConstraints = false
        completeBtn.setTitle("예약하기", for: .normal)
        completeBtn.backgroundColor =  #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        //completeBtn.addTarget(self, action: #selector(self.test(_:)), for: .touchUpInside)
        completeBtn.addTarget(self, action: #selector(self.reserveBtn(_:)), for: .touchUpInside)
        
        self.view.addSubview(completeBtn)
        
        NSLayoutConstraint.activate([
            
            //스크롤뷰 컬렉션뷰랑 동일하게 레이아웃 주기. //컬렉션뷰 줌 사용하기 위해서 테스트 중인 코드
//            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
//            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            scrollView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
//            scrollView.heightAnchor.constraint(equalTo: showSeatCollectionView.widthAnchor),
//
//
//            stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
//            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            stackView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
//            stackView.heightAnchor.constraint(equalTo: showSeatCollectionView.widthAnchor),
//
            
            
            //컬렉션뷰 레이아웃 주기 / 추가 라인 96 ~ 100
            showSeatCollectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            showSeatCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showSeatCollectionView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            showSeatCollectionView.heightAnchor.constraint(equalTo: showSeatCollectionView.widthAnchor),
            
            
            currentDay.topAnchor.constraint(equalTo: showSeatCollectionView.bottomAnchor, constant: 10),
            currentDay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentDay.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            currentDay.heightAnchor.constraint(equalTo: currentDay.widthAnchor, multiplier: 0.15),
            
            
                
            // startLb, endLb, startTime, endTime, completeBtn
            startLb.topAnchor.constraint(equalTo: currentDay.bottomAnchor),
            startLb.leadingAnchor.constraint(equalTo: currentDay.leadingAnchor),
            startLb.widthAnchor.constraint(equalTo: currentDay.widthAnchor, multiplier: 0.5),
            startLb.heightAnchor.constraint(equalTo: currentDay.heightAnchor, multiplier: 0.5),
            
            endLb.topAnchor.constraint(equalTo: currentDay.bottomAnchor),
            endLb.trailingAnchor.constraint(equalTo: currentDay.trailingAnchor),
            endLb.widthAnchor.constraint(equalTo: currentDay.widthAnchor, multiplier: 0.5),
            endLb.heightAnchor.constraint(equalTo: currentDay.heightAnchor, multiplier: 0.5),
            
            refreshBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            refreshBtn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            //refreshBtn.widthAnchor.constraint(equalTo: currentDay.widthAnchor),
            refreshBtn.leadingAnchor.constraint(equalTo: startLb.leadingAnchor),
            refreshBtn.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            refreshBtn.heightAnchor.constraint(equalTo: currentDay.heightAnchor),
            
            completeBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completeBtn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
           
            completeBtn.leadingAnchor.constraint(equalTo: view.centerXAnchor),
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
    
    override func viewWillAppear(_ animated: Bool) {    //뷰 로드 전 알림창 띄우기 위해서 willAppear사용
        super.viewWillAppear(animated)
        
        let nextPage = UIAlertController(title: "예약", message: "최대 예약 시간은 4시간 입니다", preferredStyle: UIAlertController.Style.alert)
        let nextPageAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
        nextPage.addAction(nextPageAction)
        ReserveViewController().modalPresentationStyle = .fullScreen
        present(nextPage, animated: true, completion: nil)
        
        }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        //시작시간 데이트피커 시간 반올림 세팅 -> ex. 현재시간 36분 -> 설정자체를 40분으로 초기 세팅함.
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
        
        endHour += 2
        endDateComponents.hour = endHour
        endDateComponents.minute = startDateComponents.minute
        guard let addHour = calendar.date(from: endDateComponents) else {
            print("wwwwww")
            return
        }
        
        endTime.date = addHour
        
        
        
        print("데이트피커 시간 표시 : \(startTime.date)") //이것도 9시간 더해줘야함.
    
       
        //좌석 샘플 표시 스택뷰 생성 (네비게이션 바 위에 생성)
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
      
        navigationItem.titleView = totalStackView
     
        showSeatCollectionView.minimumZoomScale = 1.0
        showSeatCollectionView.maximumZoomScale = 5
        
        print("ReserveViewController의 viewDidLoad가 출력됩니다")
        view.backgroundColor = .white
        
        //컬렉션뷰 delegate, datasource 호출 및 register주기
        showSeatCollectionView.dataSource = self
        showSeatCollectionView.delegate = self
        showSeatCollectionView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: CollectionCell.identifire)
        
    }
    
    
    
    @objc func reserveBtn(_ sender: UIButton) {
        btnDatePicker(firstDatePicker: startTime, secondDatePicker: endTime)
        
    }
    
    func btnDatePicker(firstDatePicker: UIDatePicker, secondDatePicker: UIDatePicker){
        let leftDatePickerView = firstDatePicker
        let rightDatePickerView = secondDatePicker
        
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH"
        let minFormatter = DateFormatter()
        minFormatter.dateFormat = "mm"
        
        
        let startHour = hourFormatter.string(from: leftDatePickerView.date)
        let startMin = minFormatter.string(from: leftDatePickerView.date)
        
        
        
        
        let currentDayFomatter = DateFormatter()
        currentDayFomatter.locale = Locale(identifier: "ko")
        currentDayFomatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let startTimeString = currentDayFomatter.string(from: leftDatePickerView.date)
        let startTimeDate:Date = currentDayFomatter.date(from: startTimeString)!
        let startTimeLong = Int(startTimeDate.timeIntervalSince1970) * 1000
        UserDefaults.standard.set(startTimeLong, forKey: "userStartTime")
        
        let showFormatter = DateFormatter()
        showFormatter.locale = Locale(identifier: "ko")
        showFormatter.dateFormat = "HH시 mm분"
        let showStartTime = showFormatter.string(from: leftDatePickerView.date)
        UserDefaults.standard.set(showStartTime, forKey: "startTimeString")
        
        
        
        let endTimeString = currentDayFomatter.string(from: rightDatePickerView.date)
        let endTimeDate:Date = currentDayFomatter.date(from: endTimeString)!
        let endTimeLong = Int(endTimeDate.timeIntervalSince1970) * 1000
        
        
        
        
        
        
        UserDefaults.standard.set(endTimeLong, forKey: "userEndTime")
        
        let showEndTime = showFormatter.string(from: rightDatePickerView.date)
        UserDefaults.standard.set(showEndTime, forKey: "endTimeString")
        
        
        let nowTime = Int(Date().timeIntervalSince1970) * 1000
        UserDefaults.standard.set(nowTime, forKey: "nowTime")
        
        
        
        
        
        
        let endHour = hourFormatter.string(from: rightDatePickerView.date)
        let endMin = minFormatter.string(from: rightDatePickerView.date)
        
        let start = (Int(startHour)! * 60) + Int(startMin)!
        let end = (Int(endHour)! * 60) + Int(endMin)!
        let startk = (end - start) / 60
        let startkk = (end - start) % 60
        
        if (end - start) > 0 &&  (end - start) <= 240 {
            print("이용시간은 \(startHour)시 \(startMin)분 ~ \(endHour)시 \(endMin)분")
            print("begin: \(UserDefaults.standard.integer(forKey: "userStartTime"))")
            print("end: \(UserDefaults.standard.integer(forKey: "userEndTime"))")
            let firstAlert = UIAlertController(title: "예약", message: "\(UserDefaults.standard.string(forKey: "selectedSeatNumber")!)번 \n \(startHour)시 \(startMin)분 ~ \(endHour)시 \(endMin)분 \n 총 이용시간: \(startk)시간 \(startkk)분", preferredStyle: UIAlertController.Style.alert)
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
            
        } else if (end - start) >= 0 && (end - start) < 15 {
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
        
        
        let studentId: String = UserDefaults.standard.dictionary(forKey: "studentInfo")?["studentId"]! as! String
        let college: String = UserDefaults.standard.dictionary(forKey: "studentInfo")?["college"]! as! String
        let room: String = UserDefaults.standard.string(forKey: "roomName")!
        let seat: Int = UserDefaults.standard.integer(forKey: "selectedSeatNumber")
        let time: Int = UserDefaults.standard.integer(forKey: "nowTime")
        let begin: Int = UserDefaults.standard.integer(forKey: "userStartTime")
        let end: Int = UserDefaults.standard.integer(forKey: "userEndTime")
        let ID: String = UserDefaults.standard.dictionary(forKey: "studentInfo")?["id"]! as! String
        let PW: String = UserDefaults.standard.dictionary(forKey: "studentInfo")?["password"]! as! String
        
      
        let reservedURL = "http://3.34.174.56:8080/room/reserve"
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
                
                print(value)
                if let jsonObj = value as? NSDictionary {
                    let getResult: Bool? = jsonObj.object(forKey: "result") as? Bool
                    //let getMessage: String? = jsonObj.object(forKey: "message") as? String
                    print("getresult :: \(getResult!)")
                    if getResult! {
                        print("좌석을 예약중입니다.")
                    
                        print("좌석이 예약되었습니다.")
                        
                       
                    
                    }
                    else {
                        print(getResult!)
                        
                        print("예약이 불가능합니다..")
                    }
                    
                }
                
            case .failure(_):
                print("error")
            }
            
            
            }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
}

//컬렉션 뷰 확장 관련 코드        / 234~ end
extension ReserveViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("totalCount가 리턴되는 extension이 호출됩니다.")
        return UserDefaults.standard.integer(forKey: "totalCount")
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifire, for: indexPath) as! CollectionCell
        UserDefaults.standard.set(indexPath[1], forKey: "indexPath")
        
        let columnNumber:Int = ((indexPath[1]) / UserDefaults.standard.integer(forKey: "columnCount")) // 열 구하기
        UserDefaults.standard.set(columnNumber, forKey: "columnNumber")
        
        let arrayT: [Any] = UserDefaults.standard.array(forKey: "seatInfo")![columnNumber] as! [Any]
        UserDefaults.standard.set(arrayT, forKey: "arrayT")
        
        let curr:Int = arrayT[indexPath[1]%(UserDefaults.standard.integer(forKey: "columnCount") )] as! Int
        UserDefaults.standard.set(curr, forKey: "curr")
       
        
        switch curr{
        case SeatType.Wall.rawValue:
           
            cell.myLabel.text = ""
            cell.myImageView.image = UIImage(named: "wall.png")
            cell.myImageView.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.width)
            break

        case SeatType.Door.rawValue:
            cell.myLabel.text = ""
            cell.myImageView.image = UIImage(named: "door.jpeg")
            cell.myImageView.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.width)
            break

        case SeatType.Empty.rawValue:
            cell.myLabel.text = ""
            cell.myImageView.image = UIImage(named: "road.png")
            cell.myImageView.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.width)
            break

        default:
            
            
//
//
//
//
//            
            let college: String = String(utf8String: UserDefaults.standard.dictionary(forKey: "studentInfo")!["college"] as! String)! //2층

                    let reserveURL = "http://3.34.174.56:8080/rooms"
                    let PARAM: Parameters = [
                        "college": college,

                    ]



                    let alamo = AF.request(reserveURL, method: .post, parameters: PARAM).validate(statusCode: 200..<450)
                    alamo.responseJSON() {[self] response in
                        switch response.result {
                        case.success(let value):
                            print("success")
                            if let jsonObj = value as? NSDictionary {
                                let getResult: Bool? = jsonObj.object(forKey: "result") as? Bool
                                if getResult! {

                                    //UserDefaults.standard.set(jsonObj.object(forKey: "rooms"), forKey: "qhsdml")
                                    let tmp: NSArray = jsonObj.object(forKey: "rooms") as! NSArray
                                    print(type(of: tmp))
                                    print("tmp 출력 \(tmp)")
                                    let kkk: NSDictionary = tmp[0] as! NSDictionary
                                    print("kkk")
                                    let aaa = kkk["reserved"] as! Array<Any>


                                    if (aaa[curr] as AnyObject).count == 0 {
                                        cell.myImageView.image = UIImage(named: "emptySeat.png")
                                        cell.myImageView.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.width)



                                        cell.myButton.setTitle(String(curr), for: .normal)

                                        cell.myButton.tintColor = .black
                                        cell.myButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 7)
                                        cell.myButton.addTarget(self, action: #selector(tapBtn(_:)), for: .touchUpInside)
                                        cell.myButton.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.width)

                                        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
                                    } else {


//                                        let kkkkk = TimeInterval(ccc["begin"] as! Int) / 1000
                                        //                                let aaaaa = Date(timeIntervalSince1970: kkkkk)
                                        //                                print("변환된 시간 값:::::::::::: \(aaaaa)")

                                        let currentDayFomatter = DateFormatter()
                                        currentDayFomatter.locale = Locale(identifier: "ko")
                                        currentDayFomatter.dateFormat = "yyyy-MM-dd HH:mm"

                                        let startTimeString = currentDayFomatter.string(from: startTime.date)
                                        let startTimeDate:Date = currentDayFomatter.date(from: startTimeString)!
                                        let startTimeLong = Int(startTimeDate.timeIntervalSince1970) * 1000 //실질적으로 시간 비교에 사용 되는 시간 값

                                        let endTimeString = currentDayFomatter.string(from: endTime.date)
                                        let endTimeDate:Date = currentDayFomatter.date(from: endTimeString)!
                                        let endTimeLong = Int(endTimeDate.timeIntervalSince1970) * 1000 //실질적으로 시간 비교에 사용 되는 시간 값

                                        let bbb = aaa[curr] as! Array<Any>
                                        for i in 0..<(aaa[curr] as AnyObject).count {
                                            let ccc = bbb[i] as! Dictionary<String, Any>
                                            let begin = ccc["begin"] as! Int    //예약된 좌석의 시작시간
                                            let end = ccc["end"] as! Int        //예약된 좌석의 종료시간


                                            if startTimeLong < end && endTimeLong > begin {
                                                if ccc["confirmed"] as! Int == 0 {
                                                    cell.myImageView.image = UIImage(named: "ingSeat.png")
                                                    cell.myImageView.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.width)



                                                    cell.myButton.setTitle(String(curr), for: .normal)

                                                    cell.myButton.tintColor = .black
                                                    cell.myButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 7)
                                                    cell.myButton.addTarget(self, action: #selector(tapBtn(_:)), for: .touchUpInside)
                                                    cell.myButton.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.width)
                                                    cell.myButton.isEnabled = true
                                                    cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
                                                } else {
                                                    cell.myImageView.image = UIImage(named: "fullSeat.png")
                                                    cell.myImageView.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.width)



                                                    cell.myButton.setTitle(String(curr), for: .normal)

                                                    cell.myButton.tintColor = .black
                                                    cell.myButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 7)
                                                    cell.myButton.addTarget(self, action: #selector(tapBtn(_:)), for: .touchUpInside)
                                                    cell.myButton.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.width)
                                                    cell.myButton.isEnabled = true
                                                    cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
                                                }
                                            } else {

                                                cell.myImageView.image = UIImage(named: "emptySeat.png")
                                                cell.myImageView.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.width)



                                                cell.myButton.setTitle(String(curr), for: .normal)

                                                cell.myButton.tintColor = .black
                                                cell.myButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 7)
                                                cell.myButton.addTarget(self, action: #selector(tapBtn(_:)), for: .touchUpInside)
                                                cell.myButton.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.width)
                                                cell.myButton.isEnabled = true
                                                cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
                                            }


                                        }


                                    }










                                }
                            }
                        case .failure(_):
                            print("error")
                        }

                    }




           
        }
        
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
        print(111111)
        
//        let selectSeat = UIAlertController(title: "선택 좌석", message: "\(UserDefaults.standard.string(forKey: "selectedSeatNumber")!)번을 선택하셨습니다.", preferredStyle: UIAlertController.Style.alert)
//        //let cancelSeat = UIAlertAction(title: "다시 선택", style: UIAlertAction.Style.default, handler: { action in TestCell().qqqq(sender)})
//        //let confirmSeat = UIAlertAction(title: "자리 선택", style: UIAlertAction.Style.default, handler: { action in TestCell().qwer(sender)})
//        let cancelSeat = UIAlertAction(title: "다시 선택", style: UIAlertAction.Style.default, handler: nil)
//        let confirmSeat = UIAlertAction(title: "자리 선택", style: UIAlertAction.Style.default, handler: nil)
//        selectSeat.addAction(cancelSeat)
//        selectSeat.addAction(confirmSeat)
//        present(selectSeat, animated: true, completion: nil)
        
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (Int(collectionView.frame.width)) / (UserDefaults.standard.integer(forKey: "columnCount") + 1) ///  3등분하여 배치, 옆 간격이 1이므로 1을 빼줌
            
        let size = CGSize(width: width, height: width) //이렇게 주게 되면 한줄에 4개씩 보여지게 됌 240번 줄 return 16으로 수정하면 확인 가능
        return size
    }

}
