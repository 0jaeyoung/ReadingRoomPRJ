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
    
    //현재 좌석을 보여주는 컬렉션뷰 생성 /  추가된 라인(20~28)
    let showSeatCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.lightGray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func loadView() {
        super.loadView()
        
        //컬렉션뷰 생성 라인 34 추가
        self.view.addSubview(showSeatCollectionView)

        
//        showCurrentSeat = UILabel()
//        showCurrentSeat.translatesAutoresizingMaskIntoConstraints = false
//        showCurrentSeat.text = "서버에서 자리정보 불러올 예정"
//        showCurrentSeat.backgroundColor = .gray
//        self.view.addSubview(showCurrentSeat)
        
        
        
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
            
            //컬렉션뷰 레이아웃 주기 / 추가 라인 96 ~ 100
            showSeatCollectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            showSeatCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showSeatCollectionView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            showSeatCollectionView.heightAnchor.constraint(equalTo: showSeatCollectionView.widthAnchor),
            
            //
            
//            showCurrentSeat.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
//            showCurrentSeat.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            showCurrentSeat.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
//            showCurrentSeat.heightAnchor.constraint(equalTo: showCurrentSeat.widthAnchor),
//
            
            //showCurrentSeat ->showSeatCollectionView 로 수정됨
            currentDay.topAnchor.constraint(equalTo: showSeatCollectionView.bottomAnchor, constant: 10),
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
            //startTime.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.17),
            
            endTime.topAnchor.constraint(equalTo: endLb.bottomAnchor),
            endTime.bottomAnchor.constraint(equalTo: completeBtn.topAnchor, constant: -10),
            endTime.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            endTime.trailingAnchor.constraint(equalTo: endLb.trailingAnchor),
            //endTime.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.17)
            
            
        ])
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        //컬렉션뷰 delegate, datasource 호출 및 register주기
        showSeatCollectionView.dataSource = self
        showSeatCollectionView.delegate = self
        showSeatCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        
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

//컬렉션 뷰 확장 관련 코드        / 234~ end

extension ReserveViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
    
        //return 1       //보여지는 검은 블럭 갯수 -> seat.count 처럼 배열 길이로 불러오면 될듯 한데...
        //return 16 -> 정사각형 크기에 4*4로 들어가기 때문에 스크롤이 생기지 않음
        return 24   //정사각형에 4* 6 으로 들어가기 때문에 좌석 배치 스크롤 생김 -> 만약 좌석을 정사각형으로 보여주면 스크롤 안생기게 추후 보여줄 수 있을 듯
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var allSeat: [Any] = []
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        
        //좌석 배열 불러오는지 테스트 위해서 변수 명 지정 -> 수정 필요
        var testCall = UserDefaults.standard.dictionary(forKey: "roomInfo")!["seat"] as! [Any]
        print("kkkkkkkk")
        for i in 0..<4 {
            allSeat.append(testCall[i] as! Array<Int>)
        
        }
        print("allSeat::: \(allSeat)")      //배열을 불러오는 것은 성공했지만 array[i][j] 처럼 2차원 배열로는 접근이 되지 않음...
        //본의 생각 : 각각의 [i][j]에서 j 에 해당하는 값을 바탕으로 버튼 + 색깔로 좌석을 표시하면 될꺼라고 생각했지만 위에서 말한것 처럼 접근이 되지 않음...
        
        
        cell.backgroundColor = .black
        return cell
        
        
    }
       


}

extension ReserveViewController: UICollectionViewDelegate {

}


extension ReserveViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt seection: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let width = collectionView.frame.width / 4 - 1 ///  3등분하여 배치, 옆 간격이 1이므로 1을 빼줌
            
            let size = CGSize(width: width, height: width) //이렇게 주게 되면 한줄에 4개씩 보여지게 됌 240번 줄 return 16으로 수정하면 확인 가능
            return size
        }

}


