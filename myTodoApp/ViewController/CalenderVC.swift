//
//  CalenderVC.swift
//  myTodoApp
//  달력 만들기 도전!!
//  Created by 김창규 on 2022/11/25.
//

import Foundation
import UIKit

/*
class CalenderVC: ViewController {
    
    @IBOutlet var myCollectionView: UICollectionView!
    
    //달력 관련된 변수 선언부
    let nowDate = Date()
    let calendar = Calendar.current
    let dateComponent = DateComponents()
    var weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    var days: [String] = []
    var daysCountInMonth = 0
    var weekdayAdding = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CalenderVC - viewDidLoad() called")
        //myCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        
        self.calculation()
    }
    
    private func calculation() {
        print("CalenderVC - calcuration() called")
        let firstDayOfMonth = calendar.date(from: dateComponent)
        let firstWeekday: Int = calendar.component(.weekday, from: firstDayOfMonth!)
        
        daysCountInMonth = calendar.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
        weekdayAdding = 7 -  firstWeekday
        
        self.days.removeAll()
        for day in weekdayAdding...daysCountInMonth {
            if day < 1 {
                self.days.append("")
            } else {
                self.days.append(String(day))
            }
        }
        print(days)
    }
    
}

extension CalenderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.weeks.count
        default:
            return self.days.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        
        switch indexPath.section {
        case 0:
            cell.collectionViewLabel.text = weeks[indexPath.row]
        default:
            cell.collectionViewLabel.text = days[indexPath.row]
        }
        if indexPath.row % 7 == 0 {
            cell.collectionViewLabel.textColor = .red
        } else if indexPath.row % 7 == 6 {
            cell.collectionViewLabel.textColor = .blue
        } else {
            cell.collectionViewLabel.textColor = .black
        }
        
        //cell.collectionViewLabel.text = days[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let myBoundSize: CGFloat = UIScreen.main.bounds.size.width
        let cellSize: CGFloat = myBoundSize / 10
        return CGSize(width: cellSize, height: cellSize)
    }
}
*/
