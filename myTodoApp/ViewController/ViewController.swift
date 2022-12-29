///
//  ViewController.swift
//  myTodoApp
//
//  Created by gogochang on 2022/11/16.
//

import UIKit // UI구성
import Alamofire // http 통신할 때 사용
import Toast_Swift //액션 결과를 표시할 때 사용
import Lottie // 회원가입완료 애니메이션할 때 사용
import SideMenu


class ViewController: UIViewController, SideMenuNavigationControllerDelegate {
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var calendarButtonTitle: UIButton!
    @IBOutlet var weekdayTitles: UICollectionView!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var chatButton: UIButton!
    
    //달력 관련된 변수 선언부
    let nowDate = Date()
    let cal = Calendar.current
    var dateComponent = DateComponents()
    let dateFormatter = DateFormatter()
    let toastFormatter = DateFormatter()
    var weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    
    var prevDays: [String] = []
    var crntDays: [String] = []
    var nextDays: [String] = []
    var daysCountInMonth = 0
    var weekdayAdding = 0
    
    var oldCell: DateCVCell? = nil
    var oldCellDay: String = ""
    
    var currentIndexPath: Int = 0
    var isClickedButtonName: String?
    var orderIndex: [Int] = []
    
    // 리스트 업데이트 할지 안할지
    var dataInfoDictionary: [Int: dataInfo] = [:]
    
    var isResetArray: Bool = true
    var addingArray: [dataInfo] = []
    var dataInfoArray: [dataInfo] = []
    var allDataInfoArray: [dataInfo] = []
    var todayDataInfoArray: [dataInfo] = []
    
    var selectedDate: String = ""
    var dateOfDataInfo: [String] = []
    var initCalendar: Bool = true
    
    // LoginVC에서 가져오는 계정 정보 데이터
    var username: String?
    var email: String?
    var password: String?
    
    var currentDate: String?
    
    // 스크롤방향을 확인하려는 변수
    // TODO: 방향을 담기좋은 효율적인 변수를 찾아야 한다. 리펙토링 필요
    var swipeDirection: String = ""
    //###################################################################################
    
    lazy var disabledMainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.alpha = 0.7
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    lazy var previousCalendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DateCVCell.self, forCellWithReuseIdentifier: "DateCVCell")
        collectionView.collectionViewLayout.invalidateLayout()
        return collectionView
    }()
    
    lazy var currentCalendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DateCVCell.self, forCellWithReuseIdentifier: "DateCVCell")
        collectionView.collectionViewLayout.invalidateLayout()
        return collectionView
    }()
    
    lazy var nextCalendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DateCVCell.self, forCellWithReuseIdentifier: "DateCVCell")
        collectionView.collectionViewLayout.invalidateLayout()
        return collectionView
    }()
    
    func setUpSideMenuNavigationVC(vc: ViewController, menuNavVC: SideMenuNavigationController) {
         menuNavVC.statusBarEndAlpha = 0
         menuNavVC.dismissOnPresent = true
         menuNavVC.dismissOnPush = true
         menuNavVC.enableTapToDismissGesture = true
         menuNavVC.enableSwipeToDismissGesture = true
         menuNavVC.enableSwipeToDismissGesture = true
         menuNavVC.sideMenuDelegate = vc
         menuNavVC.menuWidth = 238
         menuNavVC.presentationStyle = .menuSlideIn
         SideMenuManager.default.rightMenuNavigationController = menuNavVC
         SideMenuManager.default.rightMenuNavigationController = menuNavVC
         SideMenuManager.default.rightMenuNavigationController?.setNavigationBarHidden(true, animated: true)
     }
    
    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        self.disabledMainImageView.isHidden = true
    }
    
    //###################################################################################
    override func viewDidLoad() {
        print("ViewController - viewDidLoad() called")
        super.viewDidLoad()
        
        disabledMainImageView.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        //###################################################################################
        
        view.addSubview(contentScrollView)
        contentScrollView.topAnchor.constraint(equalTo: weekdayTitles.bottomAnchor).isActive = true
        contentScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        contentScrollView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        let screenSize = UIScreen.main.bounds
        contentScrollView.contentSize = CGSize(width: 300, height: 300)
        
        let width = screenSize.width
        let xPosition = self.view.frame.width * CGFloat(0)
        previousCalendarCollectionView.frame = CGRect(x: xPosition, y: 0, width: width, height: 300)
        contentScrollView.contentSize.width = self.view.frame.width * 1
        
        contentScrollView.addSubview(previousCalendarCollectionView)
        
        let xPosition1 = self.view.frame.width * CGFloat(1)
        currentCalendarCollectionView.frame = CGRect(x: xPosition1, y: 0, width: width, height: 300)
        contentScrollView.contentSize.width = self.view.frame.width * 2
        contentScrollView.addSubview(currentCalendarCollectionView)
        
        let xPosition2 = self.view.frame.width * CGFloat(2)
        nextCalendarCollectionView.frame = CGRect(x: xPosition2, y: 0, width: width, height: 300)
        contentScrollView.contentSize.width = self.view.frame.width * 3
        contentScrollView.addSubview(nextCalendarCollectionView)
        
        contentScrollView.setContentOffset(CGPoint(x: xPosition1, y: 0), animated: false)
        
        view.addSubview(disabledMainImageView)
        disabledMainImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        disabledMainImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        disabledMainImageView.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        disabledMainImageView.heightAnchor.constraint(equalToConstant: screenSize.height).isActive = true
        
        //###################################################################################
        
//        guard let tableview else { return }
//        guard let countLabel else { return }
//        guard let username = self.username else { return }
        disabledMainImageView.isHidden = true
        self.overrideUserInterfaceStyle = .light

        getDatainfo()
        
        tableview.layer.cornerRadius = 15
        countLabel.text = "총 \(dataInfoArray.count) 개의 메모가 있습니다."
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.dragInteractionEnabled = true

        // calendar 지정
        weekdayTitles.delegate = self
        weekdayTitles.dataSource = self
        
        dateFormatter.dateFormat = "yyyy년 MM월"
        toastFormatter.dateFormat = "yyyy-MM-dd"
        dateComponent.year = cal.component(.year, from: nowDate)
        dateComponent.month = cal.component(.month, from: nowDate)
        dateComponent.day = 1
        self.prevCalendarCalculation()
        self.calendarCalculation()
        self.nextCalendarCalculation()
        
        tableview.layer.borderWidth = 0.5
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewController viewWillAppear() called")
        let arr = selectedDate.split(separator: "-")
        if arr.isEmpty == false {
            getDatainfo()
            dateComponent.month = Int(arr[1])
            
            self.prevCalendarCalculation()
            self.calendarCalculation()
            self.nextCalendarCalculation()
            
            previousCalendarCollectionView.reloadData()
            currentCalendarCollectionView.reloadData()
            nextCalendarCollectionView.reloadData()
            contentScrollView.setContentOffset(CGPoint(x: self.view.frame.width * CGFloat(1), y: 0), animated: false)
            self.tableview.reloadData()
        }
    }
    
    //MARK: - 달력 Title 클릭 시 현재 달력으로
    @IBAction func calendarTitleClicked(_ sender: UIButton) {
        print("ViewController - calendarTitleClicked")
        
        dateComponent.year = cal.component(.year, from: nowDate)
        dateComponent.month = cal.component(.month, from: nowDate)
        
        self.prevCalendarCalculation()
        self.calendarCalculation()
        self.nextCalendarCalculation()

        previousCalendarCollectionView.reloadData()
        currentCalendarCollectionView.reloadData()
        nextCalendarCollectionView.reloadData()
        contentScrollView.setContentOffset(CGPoint(x: self.view.frame.width * CGFloat(1), y: 0), animated: false)
        self.tableview.reloadData()
    }
    //MARK: - Add 버튼 클릭 이벤트
    @IBAction func addButtonClicked(_ sender: UIButton) {
        print("ViewController - addButtonClicked() called")
        isClickedButtonName = "addButton"
        
        
        let storyboard = UIStoryboard.init(name: "PopUp", bundle: nil)
        let customPopUpVC = storyboard.instantiateViewController(withIdentifier: "AlertPopUpVC") as! CustomPopUpViewController
        
        // 뷰컨트롤러가 보여지는 스타일
        customPopUpVC.modalPresentationStyle = .overCurrentContext
        // 뷰컨트롤러가 사라지는 스타일
        customPopUpVC.modalTransitionStyle = .crossDissolve
        
        customPopUpVC.myPopUpDelegate = self
        
        customPopUpVC.clickedAddBtn = true
        
        //현재 VC위에 customPopVC를 보여준다. animation 효과 , 해당액션은 nil
        self.present(customPopUpVC, animated: true, completion: nil)
    }
    
    //MARK: - Switch 버튼 클릭 이벤트 함수 true/false
    @IBAction func UISwitchClicked(_ sender: UISwitch) {
        print("ViewController - UISwitchClicked() called")
        let contentView = sender.superview
        let cell = contentView?.superview as! UITableViewCell
        
        if let indexPath = tableview.indexPath(for: cell) {
            
            self.dataInfoArray[indexPath.row].attributes.isDone = sender.isOn
            
            putDatainfo(id: dataInfoArray[indexPath.row].id,
                        title: dataInfoArray[indexPath.row].attributes.title,
                        isDone: dataInfoArray[indexPath.row].attributes.isDone,
                        index: dataInfoArray[indexPath.row].attributes.index,
                        date: dataInfoArray[indexPath.row].attributes.date,
                        username: dataInfoArray[indexPath.row].attributes.UserName)
        }
    }

    //MARK: - 사이드메뉴 버튼 클릭 이벤트
    @IBAction func menuButtonClicked(_ sender: UIButton) {
        print("ViewController - menuButtonClicked called")
        self.disabledMainImageView.isHidden = false
        let storyboard = UIStoryboard(name: "SideMenu", bundle: nil)
        let sideMenuVC = storyboard.instantiateViewController(identifier: "SideMenuVC") as! SideMenuVC
        let sideMenuNav = SideMenuNavigationController(rootViewController: sideMenuVC)
        
        setUpSideMenuNavigationVC(vc: self, menuNavVC: sideMenuNav)
        
        sideMenuVC.name = self.username
        sideMenuVC.email = self.email
        sideMenuVC.todayDatainfo = self.todayDataInfoArray
        
        let sideMenu = SideMenuManager.default.rightMenuNavigationController!
        self.present(sideMenu, animated: true)
    }
    
//    //MARK: - 검색 버튼 클릭 이벤트
    @IBAction func searchButtonClicked(_ sender: Any) {
        print("ViewController - searchButtonClicked() called")
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        guard let pushVC = storyboard.instantiateViewController(withIdentifier: "SearchVC") as? SearchVC else { return }
        pushVC.allDataInfoArray = self.allDataInfoArray
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
    //MARK: - 채팅 버튼 클릭 이벤트
    @IBAction func chatButtonClicked(_ sender: Any) {
        print("ViewController - chatButtonClicked() called")
    }
}

//MARK: - 테이블뷰 셀 뷰객체
class CustomCell: UITableViewCell {
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var UISwitch: UISwitch!
    @IBOutlet var writerText: UILabel!
    var ofIndex: Int?
}
//MARK: - 달력 요일 텍스트
class WeekDayTitleCell: UICollectionViewCell {
    @IBOutlet var weekDayTitle: UILabel!
}

//MARK: - 달력 콜렉션뷰 셀 뷰객체
class DateCVCell: UICollectionViewCell {
    static let identifier: String = "DateCVCell"
    var cellDate: String?
    var monthdayLabel: UILabel = {
        var label = UILabel()
        label.text = "MON"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var monthdayMarkImage: UIImageView = {
       var imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 1.25
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpView()
    }

    private func setUpView() {
        addSubview(monthdayLabel)
        monthdayLabel.topAnchor.constraint(equalTo: topAnchor , constant: 5).isActive = true
        monthdayLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        
        addSubview(monthdayMarkImage)
        monthdayMarkImage.leftAnchor.constraint(equalTo: monthdayLabel.rightAnchor, constant: 2.5).isActive = true
        monthdayMarkImage.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        monthdayMarkImage.widthAnchor.constraint(equalToConstant: 2.5).isActive = true
        monthdayMarkImage.heightAnchor.constraint(equalToConstant: 2.5).isActive = true
    }

    func configureMonthday(to month: String) {
        monthdayLabel.text = month
    }

    required init?(coder: NSCoder) {
        fatalError("do not use in storyboard!")
    }

    func setDateOfCell(date: String) {
        self.cellDate = date
    }
}


//MARK: - 리스트 테이블뷰 Cell 개수, Cell 구현부
extension ViewController: UITableViewDataSource, UITableViewDelegate, PopUpDelegate {
   
    // 테이블뷰의 갯수를 리턴해준다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("ViewController - tableview() called count \(dataInfoArray.count)")
        return dataInfoArray.count
    }
    
    // 테이블뷰 Cell의 형태를 구현하는 부분
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("ViewController - tableView() called cell settingi")
        // 인자로받은 tableView의 셀을 CustomCell로 캐스팅후 없으면 UITableViewCell의 기본클래스로 반환 아니면 다음줄 실행
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        cell.labelTitle.text = dataInfoArray[indexPath.row].attributes.title
        cell.UISwitch.isOn = dataInfoArray[indexPath.row].attributes.isDone
        cell.writerText.text = dataInfoArray[indexPath.row].attributes.UserName
        return cell
    }
    
    // cell 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    // Table View Click 이벤트 함수
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ViewController - tableview Clicked ------ \(indexPath.row)")
        
        isClickedButtonName = "tableView"
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.currentIndexPath = indexPath.row
        
        let storyboard = UIStoryboard.init(name: "PopUp", bundle: nil)
        let customPopUpVC = storyboard.instantiateViewController(withIdentifier: "AlertPopUpVC") as! CustomPopUpViewController
        
        // 선택된 테이블뷰의 내용을 팝업창에 미리 입력할수 있도록 저자
        customPopUpVC.seletedItemTitle = dataInfoArray[self.currentIndexPath].attributes.title
        
        // 뷰컨트롤러가 보여지는 스타일
        customPopUpVC.modalPresentationStyle = .overCurrentContext
        // 뷰컨트롤러가 사라지는 스타일
        customPopUpVC.modalTransitionStyle = .crossDissolve
        
        customPopUpVC.myPopUpDelegate = self
        
        //현재 VC위에 customPopVC를 보여준다. animation 효과 , 해당액션은 nil
        self.present(customPopUpVC, animated: true, completion: nil)
    }
    
    //MARK: - (팝업창 edit버튼 클릭시 동작) 테이블뷰 데이터 가져오기 위한 델리겟 의 구현부.
    func onDelegateEditButtonClicked(title: String?) {
        // 문자열 출력
        print("ViewController - onDelegateEditButtonClicked() called")
        LoadingService.showLoading()
        //가져온 데이터 타이틀이랑 내용 존재여부 확인 부분
        guard let title = title else { return }
        
        switch (isClickedButtonName) {
        // 테이블뷰 아이템 클릭
        case "tableView":
            print("ViewController - onDelegateEditButtonClicked() - tableView edit called")
            // currentIndexPath에 저장된 클릭된 테이블뷰의 인덱스값을 가져와서
            // tempArray에 대응하는 title과 content에 대입.
            dataInfoArray[self.currentIndexPath].attributes.title = title
            
            // 테이블뷰 아이템 배열을 리셋하겠다. ( didSet의 내용을 실행하겠다. )
            //self.isResetArray = true
            
            // PUT
            putDatainfo(id: dataInfoArray[self.currentIndexPath].id,
                        title: dataInfoArray[self.currentIndexPath].attributes.title,
                        isDone: dataInfoArray[self.currentIndexPath].attributes.isDone,
                        index: dataInfoArray[self.currentIndexPath].attributes.index,
                        date: dataInfoArray[self.currentIndexPath].attributes.date,
                        username: dataInfoArray[self.currentIndexPath].attributes.UserName)
            

        // 아이템 추가 버튼 클릭
        case "addButton":
            print("ViewController - onDelegateEditButtonClicked() - addButton called")
            
            self.isResetArray = true
            // POST
            postDatainfo(title: title,
                         isDone: false,
                         index: self.dataInfoArray.count,
                         date: selectedDate,
                         username: self.username!)

        case .none:
            break
        case .some(_):
            break
        }
    }
    
    //MARK: - PopUp Delete버튼 구현부
    func onDelegateDeleteButtonClicked() {
        print("ViewController - onDelegateDeleteButtonClicked() called")
        LoadingService.showLoading()
        
        self.isResetArray = true
        // method : "Delete"
        deleteDatainfo(id: dataInfoArray[self.currentIndexPath].id)
    }
}

//MARK: - Strapi Comunication ( GET, PUT, POST, DELETE )
extension ViewController {
    
    //MARK: - Strapi GET
    private func getDatainfo() {
        print("ViewController - getDatainfo() called")
        todoService.shared.getDataInfo { [weak self] (response) in
            switch(response) {
            case .success(let todoData):
                guard let self = self else { return }
                if let data = todoData as? [dataInfo] {
                    self.allDataInfoArray = data
                    var currentArray: [dataInfo] = []
                    
                    // 선택된 date의 배열을 저장하는 부분
                    for i in 0 ..< data.count {
                        if data[i].attributes.date == self.selectedDate {
                            currentArray.append(data[i])
                        }
                    }
                    
                    // 데이터 유무 날짜 표시
                    self.dateOfDataInfo.removeAll()
                    for i in 0 ..< data.count {
                        if self.dateOfDataInfo.contains(data[i].attributes.date) == false {
                            self.dateOfDataInfo.append(data[i].attributes.date)
                        }
                    }
                    
                    // datainfo.index의 순서를 기준으로 재정렬함.
                    let ascending: (dataInfo, dataInfo) -> Bool = { (lhs, rhs) in
                        return lhs.attributes.index < rhs.attributes.index
                    }
                    self.dataInfoArray = currentArray.sorted(by: ascending)
                    
                    self.countLabel.text = "총 \(self.dataInfoArray.count) 개의 메모가 있습니다."
                    
                    self.currentCalendarCollectionView.reloadData()
                    self.tableview.reloadData()
                    
                    LoadingService.hideLoading()
                    
                } else {
                    print("fail")
                }
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr - get ")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    //MARK: - Strapi PUT
    private func putDatainfo(id: Int, title: String, isDone: Bool, index: Int, date: String, username: String) {
        print("ViewController - putDatainfo() called")
        postService.shared.putDatainfo(id: id,
                                       title: title,
                                       isDone: isDone,
                                       index: index,
                                       date: date,
                                       username: username,
                                       completion: { (response) in
            switch(response) {
            case .success:
                //self.tableview.reloadData()
                print("success put ")
                self.getDatainfo()
//                self.currentCalendarCollectionView.reloadData()
//                self.tableview.reloadData()
                self.view.makeToast("아이템이 수정되었습니다", duration: 1.0)
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr put")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        })
    }
    
    //MARK: Strapi POST
    private func postDatainfo(title: String, isDone: Bool, index: Int, date: String, username: String) {
        print("ViewController - postDatainfo() called")
        postService.shared.postDatainfo(title: title,
                                        isDone: isDone,
                                        index: index,
                                        date: date,
                                        username: username,
                                        completion: { response in
            switch(response) {
            case .success:
                print("success post ")
                
                self.getDatainfo()
                self.currentCalendarCollectionView.reloadData()
                self.tableview.reloadData()
                self.view.makeToast("아이템이 추가되었습니다", duration: 1.0)
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr - post")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        })
    }
    
    //MARK: - Strapi DELETE
    private func deleteDatainfo(id: Int) {
        print("Viewcontroller - deletedDatainfo() called")
        postService.shared.deleteDatainfo(id: id, completion: { response in
            switch(response) {
            case .success:
                print("succuss delete")
                self.getDatainfo()
                self.currentCalendarCollectionView.reloadData()
                self.tableview.reloadData()
                self.view.makeToast("아이템이 삭제되었습니다", duration: 1.0)
                
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr - delete")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        })
    }
}

//MARK: - 달력 컬렉션뷰 구현부
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // 현재 달력
    private func calendarCalculation() {
        print("ViewController - calendarCalculation() called")
        
        let firstDayOfMonth = cal.date(from: dateComponent)
        let firstWeekday: Int = cal.component(.weekday, from: firstDayOfMonth!)
    
        daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
        weekdayAdding = 2 - firstWeekday
        
        self.calendarButtonTitle.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.calendarButtonTitle.setTitle(dateFormatter.string(from: firstDayOfMonth!), for: .normal)
        
        self.currentDate = dateFormatter.string(from: firstDayOfMonth!)
        self.crntDays.removeAll()
        for day in weekdayAdding...42 {
            if (day < 1) || ( day > daysCountInMonth) {
                self.crntDays.append("")
            } else {
                self.crntDays.append(String(day))
            }
        }
    }
    // 이전 달력
    private func prevCalendarCalculation() {
        print("ViewController - prevCalendarCalculation() called")
        dateComponent.day = 1
        dateComponent.month = dateComponent.month! - 1
        let firstDayOfMonth = cal.date(from: dateComponent)
        let firstWeekday: Int = cal.component(.weekday, from: firstDayOfMonth!)
        
        daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
        weekdayAdding = 2 - firstWeekday
        
        self.prevDays.removeAll()
        for day in weekdayAdding...42 {
            if (day < 1) || ( day > daysCountInMonth) {
                self.prevDays.append("")
            } else {
                self.prevDays.append(String(day))
            }
        }
        dateComponent.month = dateComponent.month! + 1
    }
    // 다음 달력
    private func nextCalendarCalculation() {
        print("ViewController - prevCalendarCalculation() called")
        dateComponent.day = 1
        dateComponent.month = dateComponent.month! + 1
        let firstDayOfMonth = cal.date(from: dateComponent)
        let firstWeekday: Int = cal.component(.weekday, from: firstDayOfMonth!)
        
        daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
        weekdayAdding = 2 - firstWeekday
        self.nextDays.removeAll()
        for day in weekdayAdding...42 {
            if (day < 1) || ( day > daysCountInMonth) {
                self.nextDays.append("")
            } else {
                self.nextDays.append(String(day))
            }
        }
        dateComponent.month = dateComponent.month! - 1
    }

    // Cell 클릭 이벤트 함수
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("ViewController - collectionView() Click Event")
        let cell = collectionView.cellForItem(at: indexPath) as! DateCVCell

        // 날짜없는부분 클릭하면 무시함
        if cell.monthdayLabel.text == "" { return }
        
        if let didSelectedCell = oldCell {
            didSelectedCell.backgroundColor = .white
        }
        
        // 리로드할때 오늘날짜로 자동 선택하도록 하는거 노노
        initCalendar = false
        
        cell.backgroundColor = .systemGray5
        oldCellDay = cell.monthdayLabel.text!
        oldCell = cell
        
        dateComponent.day = Int(crntDays[indexPath.row])
        let toastDate = cal.date(from: dateComponent)
        selectedDate = toastFormatter.string(from: toastDate!)
        self.view.makeToast(toastFormatter.string(from: toastDate!), duration: 1.0)
        getDatainfo()

    }
    
    // 컬랙션 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("ViewController - collectionView() Cell 개수")
        switch collectionView {
        case previousCalendarCollectionView:
            return self.prevDays.count
        case currentCalendarCollectionView:
            return self.crntDays.count
        case nextCalendarCollectionView:
            return self.nextDays.count
        default:
            break
        }
        return 42
    }

    // 컨렉션 쎌 구성 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("ViewController - collectionView() Cell 설정")
        if (collectionView == previousCalendarCollectionView) || (collectionView == currentCalendarCollectionView) || (collectionView == nextCalendarCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCVCell", for: indexPath) as! DateCVCell
            cell.monthdayMarkImage.isHidden = true
            var testComponent = DateComponents()
            // ---------------init----------------
            cell.layer.cornerRadius = 5
            cell.backgroundColor = .white
            cell.monthdayLabel.font = UIFont.systemFont(ofSize: 12)
            //------------------------------------
            
            if indexPath.row % 7 == 0 {
                cell.monthdayLabel.textColor = .red
            } else if indexPath.row % 7 == 6 {
                cell.monthdayLabel.textColor = .blue
            } else {
                cell.monthdayLabel.textColor = .black
            }

            switch collectionView {
                
            case previousCalendarCollectionView:
                cell.configureMonthday(to: prevDays[indexPath.row])
                testComponent.year = dateComponent.year
                testComponent.month = dateComponent.month! - 1
                testComponent.day = Int(prevDays[indexPath.row])
                let testDate = cal.date(from: testComponent)

                if cal.isDateInToday(testDate!) && (prevDays[indexPath.row] != "") {
                    cell.monthdayLabel.font = UIFont.boldSystemFont(ofSize: 15)
                }

                if self.dateOfDataInfo.contains(toastFormatter.string(from: testDate!)) && (prevDays[indexPath.row] != "") {
                    cell.monthdayMarkImage.isHidden = false
                    cell.monthdayMarkImage.backgroundColor = .orange
                } else {
                    cell.monthdayMarkImage.isHidden = true
                }
                
                if toastFormatter.string(from: testDate!) == selectedDate {
                    cell.backgroundColor = .systemGray5
                    oldCell = cell
                }
                testComponent.month = dateComponent.month! + 1
  
            case currentCalendarCollectionView:
                
                cell.configureMonthday(to: crntDays[indexPath.row])
                testComponent.year = dateComponent.year
                testComponent.month = dateComponent.month
                testComponent.day = Int(crntDays[indexPath.row])
                let testDate = cal.date(from: testComponent)
                
                if initCalendar {
                    if cal.isDateInToday(testDate!) && (crntDays[indexPath.row] != "") {
                        selectedDate = toastFormatter.string(from: testDate!)
                        self.todayDataInfoArray = dataInfoArray
                        oldCell = cell
                        cell.backgroundColor = .systemGray5
                        //initCalendar = false
                    } else {
                        cell.backgroundColor = .white
                    }
                }
                if cal.isDateInToday(testDate!) && (crntDays[indexPath.row] != "") {
                    cell.monthdayLabel.font = UIFont.boldSystemFont(ofSize: 15)
                }

                if self.dateOfDataInfo.contains(toastFormatter.string(from: testDate!)) && (crntDays[indexPath.row] != "") {
                    cell.monthdayMarkImage.isHidden = false
                    cell.monthdayMarkImage.backgroundColor = .orange
                } else {
                    cell.monthdayMarkImage.isHidden = true
                }
                
                if toastFormatter.string(from: testDate!) == selectedDate {
                    cell.backgroundColor = .systemGray5
                    oldCell = cell
                } else {
                    cell.backgroundColor = .white
                }
                
            case nextCalendarCollectionView: //cell.monthdayLabel.text = nextDays[indexPath.row]
                cell.configureMonthday(to: nextDays[indexPath.row])
                testComponent.year = dateComponent.year
                testComponent.month = dateComponent.month! + 1
                testComponent.day = Int(nextDays[indexPath.row])
                let testDate = cal.date(from: testComponent)

                if cal.isDateInToday(testDate!) && (nextDays[indexPath.row] != "") {
                    cell.monthdayLabel.font = UIFont.boldSystemFont(ofSize: 15)
                }

                if self.dateOfDataInfo.contains(toastFormatter.string(from: testDate!)) && (nextDays[indexPath.row] != "") {
                    cell.monthdayMarkImage.isHidden = false
                    cell.monthdayMarkImage.backgroundColor = .orange
                } else {
                    cell.monthdayMarkImage.isHidden = true
                }
                
                if toastFormatter.string(from: testDate!) == selectedDate {
                    cell.backgroundColor = .systemGray5
                    oldCell = cell
                }
                testComponent.month = dateComponent.month! - 1
  
                
            default:
                break
            }
            return cell
        } else if collectionView == weekdayTitles {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDayCVCell", for: indexPath) as! WeekDayTitleCell
            cell.weekDayTitle.text = weeks[indexPath.row]
            if indexPath.row % 7 == 0 {
                cell.weekDayTitle.textColor = .red
            } else if indexPath.row % 7 == 6 {
                cell.weekDayTitle.textColor = .blue
            } else {
                cell.weekDayTitle.textColor = .black
            }
            
            return cell
        }

        return DateCVCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == contentScrollView {
            switch targetContentOffset.pointee.x {
            case 0:
                self.swipeDirection = "prev"
            case self.view.frame.width * CGFloat(1):
                self.swipeDirection = "crnt"
            case self.view.frame.width * CGFloat(2):
                self.swipeDirection = "next"
            default:
                break
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        if scrollView == contentScrollView {
            switch swipeDirection {
            case "prev":
                dateComponent.day = 1
                dateComponent.month = dateComponent.month! - 1

                self.prevCalendarCalculation()
                self.calendarCalculation()
                self.nextCalendarCalculation()

                previousCalendarCollectionView.reloadData()
                currentCalendarCollectionView.reloadData()
                nextCalendarCollectionView.reloadData()
                contentScrollView.setContentOffset(CGPoint(x: self.view.frame.width * CGFloat(1), y: 0), animated: false)
            case "crnt":
                break
            case "next":
                dateComponent.day = 1
                dateComponent.month = dateComponent.month! + 1

                self.prevCalendarCalculation()
                self.calendarCalculation()
                self.nextCalendarCalculation()

                previousCalendarCollectionView.reloadData()
                currentCalendarCollectionView.reloadData()
                nextCalendarCollectionView.reloadData()
                contentScrollView.setContentOffset(CGPoint(x: self.view.frame.width * CGFloat(1), y: 0), animated: false)
              
            default:
                break
            }}
    }
    
    // 컨렉션 쎌 간격/ 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let myBoundSize: CGFloat = UIScreen.main.bounds.size.width
        let cellSize: CGFloat = myBoundSize / 9
        return CGSize(width: cellSize, height: cellSize)
    }
}
