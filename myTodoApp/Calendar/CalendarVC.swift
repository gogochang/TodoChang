////
////  CalendarVC.swift
////  myTodoApp
////
////  Created by 김창규 on 2022/12/17.
////
//
//import Foundation
//import UIKit
//
//class CalendarVC: UIViewController{
//    
//    @IBOutlet var myCalendarCollectionView: UICollectionView!
//    //달력 관련된 변수 선언부
//    let nowDate = Date()
//    let cal = Calendar.current
//    var dateComponent = DateComponents()
//    let dateFormatter = DateFormatter()
//    let toastFormatter = DateFormatter()
//    var weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
//    var days: [String] = []
//    var daysCountInMonth = 0
//    var weekdayAdding = 0
//    
//    lazy var contentScrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.backgroundColor = .orange
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.isPagingEnabled = true
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.delegate = self
//        return scrollView
//    }()
//    
//    lazy var previousCalendarCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .white
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.showsVerticalScrollIndicator = false
//        collectionView.isScrollEnabled = false
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.allowsMultipleSelection = false
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(DateCVCell.self, forCellWithReuseIdentifier: "DateCVCell")
//        collectionView.collectionViewLayout.invalidateLayout()
//    
//        return collectionView
//    }()
//    
//    lazy var currentCalendarCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .white
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.showsVerticalScrollIndicator = false
//        collectionView.isScrollEnabled = false
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.allowsMultipleSelection = false
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(DateCVCell.self, forCellWithReuseIdentifier: "DateCVCell")
//        collectionView.collectionViewLayout.invalidateLayout()
//        
//        return collectionView
//    }()
//    lazy var nextCalendarCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .white
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.showsVerticalScrollIndicator = false
//        collectionView.isScrollEnabled = false
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.allowsMultipleSelection = false
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(DateCVCell.self, forCellWithReuseIdentifier: "DateCVCell")
//        collectionView.collectionViewLayout.invalidateLayout()
//        
//        return collectionView
//    }()
//    
//    lazy var monthLabel: UILabel = {
//        var label = UILabel()
//        label.text = "e"
//        label.textAlignment = .left
//        label.textColor = UIColor.black
//        label.font = UIFont.systemFont(ofSize: 1)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    override func viewDidLoad() {
//        print("CalendarVC - viewDidLoad() called")
//        super.viewDidLoad()
//        
//        view.addSubview(contentScrollView)
//        contentScrollView.topAnchor.constraint(equalTo: view.topAnchor , constant: 150).isActive = true
//        contentScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        contentScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        contentScrollView.heightAnchor.constraint(equalToConstant: 300).isActive = true
//
//        let screenSize = UIScreen.main.bounds
//        contentScrollView.contentSize = CGSize(width: screenSize.width, height: 300)
//
//        let width = screenSize.width
//        let xPosition = self.view.frame.width * CGFloat(0)
//        previousCalendarCollectionView.frame = CGRect(x: xPosition, y: 0, width: width, height: 300)
//        contentScrollView.contentSize.width = self.view.frame.width * 1
//
//        contentScrollView.addSubview(previousCalendarCollectionView)
//
//        let xPosition1 = self.view.frame.width * CGFloat(1)
//        currentCalendarCollectionView.frame = CGRect(x: xPosition1, y: 0, width: width, height: 300)
//        contentScrollView.contentSize.width = self.view.frame.width * 2
//        contentScrollView.addSubview(currentCalendarCollectionView)
//
//        let xPosition2 = self.view.frame.width * CGFloat(2)
//        nextCalendarCollectionView.frame = CGRect(x: xPosition2, y: 0, width: width, height: 300)
//        contentScrollView.contentSize.width = self.view.frame.width * 3
//        contentScrollView.addSubview(nextCalendarCollectionView)
//
//
//        contentScrollView.setContentOffset(CGPoint(x: xPosition1, y: 0), animated: false)
//        
////        previousCalendarCollectionView.reloadData()
////        currentCalendarCollectionView.reloadData()
////        nextCalendarCollectionView.reloadData()
//    }
//    
////    private func setUpView() {
////        view.addSubview(monthLabel)
////        monthLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
////        //monthLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
////        monthLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28).isActive = true
////        monthLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
////        monthLabel.text = "2022.12"
////    }
//}
//
//class DateCVCell: UICollectionViewCell {
//    static let Identifier: String = "DateCVCell"
//    
//    var monthdayLabel: UILabel = {
//        var label = UILabel()
//        label.text = "MON"
//        label.textAlignment = .center
//        label.textColor = .black
//        label.font = UIFont.systemFont(ofSize: 10)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        setUpView()
//    }
//    
//    private func setUpView() {
//        addSubview(monthdayLabel)
//        monthdayLabel.topAnchor.constraint(equalTo: topAnchor , constant: 5).isActive = true
//        monthdayLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
//        //monthdayLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        //monthdayLabel.heightAnchor.constraint(equalToConstant: 300).isActive = true
//    }
//    
//    func configureMonthday(to month: String) {
//        monthdayLabel.text = month
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("do not use in storyboard!")
//    }
//    @IBOutlet var testText: UILabel!
//}
//
////MARK: - 달력 컬렉션뷰 구현부
//extension CalendarVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    // 컬랙션 셀 개수
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            return 35
//    }
//
//    // 컨렉션 쎌 구성 설정
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCVCell", for: indexPath) as? DateCVCell else { return UICollectionViewCell() }
//        
//        //cell.backgroundColor = .lightGray
//        cell.configureMonthday(to: String(indexPath.row))
//        
//        return cell
//    }
//    
//    // 컨렉션 쎌 간격/ 사이즈 설정
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let myBoundSize: CGFloat = UIScreen.main.bounds.size.width
//        let cellSize: CGFloat = myBoundSize / 9
//        return CGSize(width: cellSize, height: cellSize)
//    }
//
//}
//
//extension CalendarVC: UIScrollViewDelegate {
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        print("CalendarVC - scrollViewWillEndDragging() called ->",targetContentOffset.pointee.x)
////        switch targetContentOffset.pointee.x {
////        case 0:
////            print("0")
////        case 1:
////            print("1")
////
////        default:
////            break
////        }
//        
//    }
//    
//    //private func updateCalendarView(middle date: MyDataExpression
//}
//
