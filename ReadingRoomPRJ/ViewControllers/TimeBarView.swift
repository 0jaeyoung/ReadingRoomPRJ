//
//  timeBarView.swift
//  ReadingRoomPRJ
//
//  Created by MCNC on 2021/04/24.
//

import UIKit

class TimeBarView: UIScrollView {
    var currHour = Calendar.current.component(.hour, from: Date())
    var currMin = Calendar.current.component(.minute, from: Date())
    
    var currTimeItv = Date().timeIntervalSince1970
    
    let displayTime = 24
    let timeWidth = 10
    
    let oneHour = 12000000
    
    var vc = UIViewController()
    
    var reservations:NSArray!
    
    
    // MARK:- Properties
    fileprivate let cellId = "cell"
    
    lazy var myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cvWidth = timeWidth * displayTime * 6
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: cvWidth, height: 50), collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 15, right: 0)
        cv.delegate = self
        cv.dataSource = self
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    var timeScrollView: UIScrollView!
    
    convenience init(_ data: NSArray) {
        self.init()
        reservations = data
        let svWidth = timeWidth * displayTime * 6
        contentSize = CGSize(width: svWidth, height: 50)
        
        if currMin > 10 {
            // ~hh:10까지는 hh가 시각눈금에 표시
            currHour += 1
        }
        
        addSubview(myCollectionView)
    }
    
}


extension TimeBarView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 크기??
        return CGSize(width: timeWidth, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 몇개??
        return displayTime * 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.layer.borderWidth = 0.2
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 2
        
        for res in reservations {
            let curr = res as! NSDictionary
            if (currTimeItv >= TimeInterval(curr["begin"] as! Int)) && (currTimeItv < TimeInterval(curr["end"] as! Int)) {
                cell.backgroundColor = .lightGray
            } else {
                cell.backgroundColor = .white
            }
        }
        currTimeItv += 600
        // 정각에 선, 시각 추가
        if (indexPath.row + currMin/10) % 6 == 0 {
            let line = UIView(frame: CGRect(origin: CGPoint(x: cell.frame.origin.x-1, y: cell.frame.origin.y-1), size: CGSize(width: 2,height: 32)))
            let hour = UILabel()
            
            hour.text = String(format: "%02d", getHour(currHour))
            currHour += 1
            hour.font = .systemFont(ofSize: 13)
            hour.textAlignment = .center
            hour.frame = CGRect(origin: CGPoint(x: line.frame.origin.x-10, y: line.frame.maxY+1), size: CGSize(width: 20, height: 13))
            line.backgroundColor = .black
            addSubview(line)
            addSubview(hour)
        }
        
        return  cell
    }
    
    func getHour(_ i: Int) -> Int {
        var hour = i
        if i >= 24 {
            hour -= 24
        }
        return hour
    }
}
