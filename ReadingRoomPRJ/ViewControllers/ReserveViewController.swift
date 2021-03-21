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
    var completeBtn: UIButton!
    
    var rowCount:Int! // 가로 몇칸? -> it대학 기준 16
    var columnCount: Int!
    var totalCount:Int! // 전체 셀 개수. 2차원 배열 가로 * 세로
    var seatInfo: [Any] = []
    var seats = [Int:Int]()
    
    var testArray: [Any] = []
    var testArr: [Any] = []
//    var realArray = Dictionary<Int, Int> ()
//    var asceDic = Dictionary<Int, Int> ()
    
    var cellTitle: UILabel!
    var cellImg: UIImageView!
    var cellBtn: UIButton!
    var doorImg: UIImageView!
    //let emptyImage : UIImage = UIImage(named: "emptySeat.png")!
    
    
    
    enum SeatType: Int {
        case Wall = -1
        case Empty = 0
        case Door = -2
        
    }
    
    var state: Bool = true
    
    //현재 좌석을 보여주는 컬렉션뷰 생성 /  추가된 라인(20~28)
    let showSeatCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func loadView() {
        super.loadView()
        
        print("ReserveViewController의 loadView가 출력됩니다.")
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        //컬렉션뷰 생성 라인 34 추가
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
        //startTime.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
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
        
        completeBtn = UIButton(type: .system)
        completeBtn.translatesAutoresizingMaskIntoConstraints = false
        completeBtn.setTitle("예약하기", for: .normal)
        completeBtn.backgroundColor =  #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        //completeBtn.addTarget(self, action: #selector(self.test(_:)), for: .touchUpInside)
        completeBtn.addTarget(self, action: #selector(self.test(_:)), for: .touchUpInside)
        
        self.view.addSubview(completeBtn)
        
        NSLayoutConstraint.activate([
            
            //컬렉션뷰 레이아웃 주기 / 추가 라인 96 ~ 100
            showSeatCollectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            showSeatCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showSeatCollectionView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            showSeatCollectionView.heightAnchor.constraint(equalTo: showSeatCollectionView.widthAnchor),
            
            //showCurrentSeat ->showSeatCollectionView 로 수정됨
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
            
            completeBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completeBtn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            completeBtn.widthAnchor.constraint(equalTo: currentDay.widthAnchor),
            completeBtn.heightAnchor.constraint(equalTo: currentDay.heightAnchor),
            
            startTime.topAnchor.constraint(equalTo: startLb.bottomAnchor),
            startTime.bottomAnchor.constraint(equalTo: completeBtn.topAnchor, constant: -10),
            startTime.leadingAnchor.constraint(equalTo: startLb.leadingAnchor),
            startTime.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            //startTime.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.17),
            
            endTime.topAnchor.constraint(equalTo: endLb.bottomAnchor),
            endTime.bottomAnchor.constraint(equalTo: completeBtn.topAnchor, constant: -10),
            endTime.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            endTime.trailingAnchor.constraint(equalTo: endLb.trailingAnchor),
            //endTime.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.17)
            
        ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nextPage = UIAlertController(title: "예약", message: "최대 예약 시간은 4시간 입니다", preferredStyle: UIAlertController.Style.alert)
        let nextPageAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
        nextPage.addAction(nextPageAction)
        ReserveViewController().modalPresentationStyle = .fullScreen
        present(nextPage, animated: true, completion: nil)
        
        }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let kkkkk = TimeInterval(1616191200000) / 1000
        let aaaaa = Date(timeIntervalSince1970: kkkkk)
        print("변환된 시간 값:::::::::::: \(aaaaa)")
        
        
        
        
        showSeatCollectionView.minimumZoomScale = 1.0
        showSeatCollectionView.maximumZoomScale = 5
        
        print("ReserveViewController의 viewDidLoad가 출력됩니다")
        view.backgroundColor = .white
        
        //컬렉션뷰 delegate, datasource 호출 및 register주기
        showSeatCollectionView.dataSource = self
        showSeatCollectionView.delegate = self
        showSeatCollectionView.register(UINib(nibName: "TestCell", bundle: nil), forCellWithReuseIdentifier: TestCell.identifire)
        
    }
    
    @objc func test(_ sender: UIButton) {
        btn(a: startTime, b: endTime)
        //print(realArray)
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
    
    
    
    
    
//    func myInfo() {
//        print("유저의 좌석 정보를 보여줍니다.")
//        let ID: String = UserDefaults.standard.dictionary(forKey: "studentInfo")?["id"]! as! String
//        let PW: String = UserDefaults.standard.dictionary(forKey: "studentInfo")?["password"]! as! String
//
//        let myReservedURL = "http://3.34.174.56:8080/room/myReservation"
//        let PARAM: Parameters = [
//            "id": ID,
//            "password": PW
//        ]
//
//        let alamo = AF.request(myReservedURL, method: .post, parameters: PARAM).validate(statusCode: 200..<450)
//
//        alamo.responseJSON() { [self] response in
//            switch response.result {
//            case .success(let value):
//
//                print(value)
//                if let jsonObj = value as? NSDictionary {
//                    let getResult: Bool? = jsonObj.object(forKey: "result") as? Bool
//                    //let getMessage: String? = jsonObj.object(forKey: "message") as? String
//                    print("getresult :: \(getResult!)")
//                    if getResult! {
//                        let mySeatInfo: NSArray = jsonObj.object(forKey: "reservations") as! NSArray
//                        print(getResult!)
//
//                        print(mySeatInfo)
//
//
//
//                    }
//                    else {
//                        print(getResult!)
//
//                        print("예약이 불가능합니다..")
//                    }
//
//                }
//
//            case .failure(_):
//                print("통신 실패")
//            }
//
//
//            }
//
//
//
//
//    }
//
//
    
    
    
    func back() {
        print("back")
        
        
        let studentId: String = UserDefaults.standard.dictionary(forKey: "studentInfo")?["studentId"]! as! String
        let college: String = "TEST"
        let room: String = "Test"
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
                        let mySeatInfo: NSDictionary = jsonObj.object(forKey: "reservation") as! NSDictionary
                        print("좌석을 예약합니다.")
                    
                        print("좌석이 예약되었습니다.")
                        //self.myInfo()
                        
                    
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
        
        
        
        
        
        //dismiss(animated: true, completion: nil)
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
        
        // test let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestCell.identifire, for: indexPath) as! TestCell
        
      
        
        //print("indexpath[1] = \(indexPath[1])")
        UserDefaults.standard.set(indexPath[1], forKey: "indexPath")
        
        let columnNumber:Int = ((indexPath[1]) / UserDefaults.standard.integer(forKey: "columnCount")) // 열 구하기
        UserDefaults.standard.set(columnNumber, forKey: "columnNumber")
        //print("columnNumber = \(columnNumber)")
        
        
        
        let arrayT: [Any] = UserDefaults.standard.array(forKey: "seatInfo")![columnNumber] as! [Any]
        UserDefaults.standard.set(arrayT, forKey: "arrayT")
        //print(arrayT)
        let curr:Int = arrayT[indexPath[1]%(UserDefaults.standard.integer(forKey: "columnCount") )] as! Int
        UserDefaults.standard.set(curr, forKey: "curr")
        //print(curr)
        
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
            
            
            
            
            if state {
                cell.myImageView.image = UIImage(named: "emptySeat.png")
                cell.myImageView.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.width)


                //cell.myButton = UIButton(type: .system)
                cell.myButton.setTitle(String(curr), for: .normal)
                cell.myButton.tintColor = .black
                cell.myButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 7)
                //cell.myButton.addTarget(self, action: #selector(tapBtn(_:)), for: .touchUpInside)
                cell.myButton.addTarget(self, action: #selector(tapBtn(_:)), for: .touchUpInside)
                cell.myButton.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.width)
                
                
                
                cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
            } else {
                cell.myImageView.image = UIImage(named: "intSeat.png")
                cell.myImageView.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.width)


                //cell.myButton = UIButton(type: .system)
                cell.myButton.setTitle(String(curr), for: .normal)
                cell.myButton.tintColor = .black
                cell.myButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 7)
                //cell.myButton.addTarget(self, action: #selector(tapBtn(_:)), for: .touchUpInside)
                cell.myButton.addTarget(self, action: #selector(tapBtn(_:)), for: .touchUpInside)
                cell.myButton.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.width)
                
                
                
                cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
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
    
    @objc func tapBtn(_ sender: UIButton){
        print(111111)
        
        let selectSeat = UIAlertController(title: "선택 좌석", message: "\(UserDefaults.standard.string(forKey: "selectedSeatNumber")!)번을 선택하셨습니다.", preferredStyle: UIAlertController.Style.alert)
        let cancelSeat = UIAlertAction(title: "다시 선택", style: UIAlertAction.Style.default, handler: nil)
        let confirmSeat = UIAlertAction(title: "자리 선택", style: UIAlertAction.Style.default, handler: nil)
        selectSeat.addAction(cancelSeat)
        selectSeat.addAction(confirmSeat)
        present(selectSeat, animated: true, completion: nil)
        
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


