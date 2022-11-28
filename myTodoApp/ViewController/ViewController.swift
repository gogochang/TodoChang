//
//  ViewController.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/11/16.
//

import UIKit
import Alamofire
import Toast_Swift

class ViewController: UIViewController {
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var calendarTitle: UILabel!
    @IBOutlet var calendarCollectionView: UICollectionView!
    
    //달력 관련된 변수 선언부
    let nowDate = Date()
    let cal = Calendar.current
    var dateComponent = DateComponents()
    let dateFormatter = DateFormatter()
    let toastFormatter = DateFormatter()
    var weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    var days: [String] = []
    var daysCountInMonth = 0
    var weekdayAdding = 0
    
    var oldCell: MyCollectionViewCell? = nil
   
    // 리스트 업데이트 할지 안할지
    var isResetArray: Bool = true
    var addingArray: [dataInfo] = []
    var tempArray: [dataInfo] = []
    {
        didSet{
            //print("isResetArray = \(isResetArray)")
            if isResetArray {
                print("tempArray - didset")
                resetArray()
                self.isResetArray = false
            }
        }
    }
    
    //var addingArray: [dataInfo] = []
    var currentIndexPath: Int = 0
    var isClickedButtonName: String?
    var orderIndex: [Int] = []
    
    override func viewDidLoad() {
        print("ViewController - viewDidLoad() called")
        super.viewDidLoad()
        guard let tableview else { return }
        guard let countLabel else { return }
        resetArray()
        
        tableview.layer.cornerRadius = 15
        countLabel.text = "총 \(tempArray.count) 개의 메모가 있습니다."
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.dragInteractionEnabled = true
        tableview.dragDelegate = self
        tableview.dropDelegate = self
        
        // calendar 지정
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        dateFormatter.dateFormat = "yyyy년 MM월"
        toastFormatter.dateFormat = "yyyy - MM - dd"
        dateComponent.year = cal.component(.year, from: nowDate)
        dateComponent.month = cal.component(.month, from: nowDate)
        dateComponent.day = 1
        
        self.calendarCalculation()
    }
    
    //MARK: - Add 버튼
    @IBAction func addButtonClicked(_ sender: UIButton) {
        print("ViewController - addButtonClicked() called")
        isClickedButtonName = "addButton"
        
        let storyboard = UIStoryboard.init(name: "PopUp", bundle: nil)
        let customPopUpVC = storyboard.instantiateViewController(withIdentifier: "AlertPopUpVC") as! CustomPopUpViewController
        
        // 선택된 테이블뷰의 내용을 팝업창에 미리 입력할수 있도록 저자
        //customPopUpVC.seletedItemTitle = tempArray[self.currentIndexPath].attributes.title
        //customPopUpVC.seletedItemContent = tempArray[self.currentIndexPath].attributes.content
        
        // 뷰컨트롤러가 보여지는 스타일
        customPopUpVC.modalPresentationStyle = .overCurrentContext
        // 뷰컨트롤러가 사라지는 스타일
        customPopUpVC.modalTransitionStyle = .crossDissolve
        
        customPopUpVC.myPopUpDelegate = self
        
        //현재 VC위에 customPopVC를 보여준다. animation 효과 , 해당액션은 nil
        self.present(customPopUpVC, animated: true, completion: nil)
    }
    
    //MARK: - Reset 버튼 클릭 이벤트함수
    @IBAction func resetButtonClicked(_ sender: UIButton) {
        print("ViewController - resetButtonClicked() called")
        self.isResetArray = true
        resetArray()
        self.view.makeToast("아이템 목록이 리셋되었습니다", duration: 1.0)
    }
    
    //MARK: - todo list 리셋
    func resetArray() {
        print("ViewController - resetArray() called")
        todoService.shared.getDataInfo { (response) in
            switch(response) {
            case .success(let todoData):
                if let data = todoData as? [dataInfo] {
                    
                    if self.tempArray.isEmpty {
                        self.tempArray = data
                    }
                    
                    var testIndex: [[Int]] = []
                    print(self.tempArray)
                    var tempData: [dataInfo] = self.tempArray
                    
                    for i in 0...self.tempArray.count - 1 {
                        testIndex.append([self.tempArray[i].attributes.index, i])
                    }
                    
                    testIndex = testIndex.sorted(by: {$0[0] < $1[0]})
                                        
                    self.tempArray.removeAll()
                    
                    for i in 0...testIndex.count - 1 {
                        self.tempArray.append(tempData[testIndex[i][1]])
                    }

                    
                    print("EEEE###################", self.tempArray)
                    self.tableview.reloadData()
                    
                } else {
                    print("fail")
                }
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    //MARK: - Switch 버튼 클릭 이벤트 함수 true/false
    @IBAction func UISwitchClicked(_ sender: UISwitch) {
        print("ViewController - UISwitchClicked() called")
        //self.isResetArray = true
        let contentView = sender.superview
        let cell = contentView?.superview as! UITableViewCell
        
        if let indexPath = tableview.indexPath(for: cell) {
            //let orderindex = self.orderIndex[indexPath.row]
            self.tempArray[indexPath.row].attributes.isDone = sender.isOn
            // post를 해줘야될텐데,
            todoService.shared.putDatainfo(id: tempArray[indexPath.row].id,//indexPath.row,
                                           title: tempArray[indexPath.row].attributes.title,
                                           isDone: tempArray[indexPath.row].attributes.isDone,
                                           content: tempArray[indexPath.row].attributes.content,
                                           index: tempArray[indexPath.row].attributes.index,
                                           completion: { (response) in
                switch(response) {
                case .success(let todoData):
                    print("Test")
                case .requestErr(let message):
                    print("requestErr", message)
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
                }
            })
        }
        self.view.makeToast("아이템이 수정되었습니다", duration: 1.0)
    }
    
    private func calendarCalculation() {
        print("ViewController - calendarCalculation() called")
        let firstDayOfMonth = cal.date(from: dateComponent)
        let firstWeekday: Int = cal.component(.weekday, from: firstDayOfMonth!)
        daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
        weekdayAdding = 2 - firstWeekday
        
        self.calendarTitle.text = dateFormatter.string(from: firstDayOfMonth!)
        self.days.removeAll()
        for day in weekdayAdding...daysCountInMonth {
            if day < 1 {
                self.days.append("")
            } else {
                self.days.append(String(day))
            }
        }
    }
    
    @IBAction func onPrevBtnClicked(_ sender: UIButton) {
        print("ViewController - onPrevBtnClicked() called")
        dateComponent.day = 1
        dateComponent.month = dateComponent.month! - 1
        self.calendarCalculation()
        self.calendarCollectionView.reloadData()
    }
    
    @IBAction func onNextBtnClicked(_ sender: UIButton) {
        print("ViewController - onNextBtnClicked() called")
        dateComponent.day = 1
        dateComponent.month = dateComponent.month! + 1
        self.calendarCalculation()
        self.calendarCollectionView.reloadData()
        print(String(cal.component(.day, from: nowDate)))
    }

}

//MARK: - 셀 뷰객체
class CustomCell: UITableViewCell {
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var UISwitch: UISwitch!
    @IBOutlet var labelContent: UILabel!
    var ofIndex: Int?
}

//MARK: - 리스트 테이블뷰 Cell 개수, Cell 구현부
extension ViewController: UITableViewDataSource,
                          UITableViewDelegate,
                          UITableViewDragDelegate,
                          UITableViewDropDelegate,
                          PopUpDelegate {
   
    // 테이블뷰의 갯수를 리턴해준다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("ViewController - tableview() called ")
        return tempArray.count
    }
    
    // 테이블뷰 Cell의 형태를 구현하는 부분
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 인자로받은 tableView의 셀을 CustomCell로 캐스팅후 없으면 UITableViewCell의 기본클래스로 반환 아니면 다음줄 실행
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        // cell의 labelTit
        //let orderindex = tempArray[indexPath.row].attributes.index
        
        //print(" \(indexPath.row) index is  -=>  \(orderindex)")
        
        cell.labelTitle.text = tempArray[indexPath.row].attributes.title
        
        cell.labelContent.text = tempArray[indexPath.row].attributes.content
        
        cell.UISwitch.isOn = tempArray[indexPath.row].attributes.isDone
        
        return cell
    }
    
    // cell 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    // Table View Click 이벤트 함수
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ViewController - tableview Clicked ------ \(indexPath.row)")
        //let orderindex = self.orderIndex[indexPath.row]
        isClickedButtonName = "tableView"
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.currentIndexPath = indexPath.row
        
        let storyboard = UIStoryboard.init(name: "PopUp", bundle: nil)
        let customPopUpVC = storyboard.instantiateViewController(withIdentifier: "AlertPopUpVC") as! CustomPopUpViewController
        
        // 선택된 테이블뷰의 내용을 팝업창에 미리 입력할수 있도록 저자
        customPopUpVC.seletedItemTitle = tempArray[self.currentIndexPath].attributes.title
        customPopUpVC.seletedItemContent = tempArray[self.currentIndexPath].attributes.content
        
        // 뷰컨트롤러가 보여지는 스타일
        customPopUpVC.modalPresentationStyle = .overCurrentContext
        // 뷰컨트롤러가 사라지는 스타일
        customPopUpVC.modalTransitionStyle = .crossDissolve
        
        customPopUpVC.myPopUpDelegate = self
        
        //현재 VC위에 customPopVC를 보여준다. animation 효과 , 해당액션은 nil
        self.present(customPopUpVC, animated: true, completion: nil)
        
    }
    
    //MARK: - (팝업창 edit버튼 클릭시 동작) 테이블뷰 데이터 가져오기 위한 델리겟의 구현부.
    func onDelegateEditButtonClicked(title: String?, content: String?) {
        // 문자열 출력
        print("ViewController - onDelegateEditButtonClicked() called")
        //self.view.makeToast("아이템이 추가되었습니다", duration: 1.0)
        //가져온 데이터 타이틀이랑 내용 존재여부 확인 부분
        guard let title = title else { return }
        guard let content = content else { return }
        
        switch (isClickedButtonName) {
        case "tableView":
            print("ViewController - onDelegateEditButtonClicked() - tableView Switch called")
            // currentIndexPath에 저장된 클릭된 테이블뷰의 인덱스값을 가져와서
            // tempArray에 대응하는 title과 content에 대입.
            tempArray[self.currentIndexPath].attributes.title = title
            tempArray[self.currentIndexPath].attributes.content = content
            
            self.isResetArray = true
            
            // method : "PUT"
            todoService.shared.putDatainfo(id: tempArray[self.currentIndexPath].id,
                                           title: tempArray[self.currentIndexPath].attributes.title,
                                           isDone: tempArray[self.currentIndexPath].attributes.isDone,
                                           content: tempArray[self.currentIndexPath].attributes.content,
                                           index: tempArray[self.currentIndexPath].attributes.index,
                                           completion: { (response) in
                switch(response) {
                case .success(let todoData):
                    print("success - \(todoData)")
                    //self.resetArray()
                case .requestErr(let message):
                    print("requestErr", message)
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
                }
            })
            resetArray()
            self.view.makeToast("아이템이 수정되었습니다", duration: 1.0)
        case "addButton":
            print("ViewController - onDelegateEditButtonClicked() - addButton Switch called")
            self.isResetArray = true
            todoService.shared.postDatainfo(title: title, isDone: false, content: content, index: self.tempArray.count, completion: { response in
                switch(response) {
                case .success(let todoData):
                    print("success - \(todoData)")
                    //self.resetArray()
                case .requestErr(let message):
                    print("requestErr", message)
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
                }
            })
            
        case .none:
            break
        case .some(_):
            break
        }
        resetArray()
        self.view.makeToast("아이템이 추가되었습니다", duration: 1.0)
    }
    
    //MARK: - PopUp Delete버튼 구현부
    func onDelegateDeleteButtonClicked() {
        print("ViewController - onDelegateDeleteButtonClicked() called")
        self.view.makeToast("아이템이 삭제되었습니다", duration: 1.0)
        self.isResetArray = true
        // method : "Delete"
        todoService.shared.deleteDatainfo(id: tempArray[self.currentIndexPath].id,
                                          completion: { response in
            switch(response) {
            case .success(let todoData):
                print("success - \(todoData)")
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        })
        
        resetArray()
    }
    
    //MARK: - UITableView UITableViewDragDelegate
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        print("ViewController - tableView Drag()  \(tempArray[indexPath.row].attributes.title)")
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    
    //MARK: - UITableView UITableViewDropDelegate
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        print("ViewController - tableView Drop()")
        if session.localDragSession != nil {
            //print("session.localDragSession is not nil -> \(destinationIndexPath)")
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        //print("session.localDragSession is nil")
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
        
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {}
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("ViewController - moveRowAt() Called")
        let moveCell = self.tempArray[sourceIndexPath.row]
        self.tempArray.remove(at: sourceIndexPath.row)
        self.tempArray.insert(moveCell, at: destinationIndexPath.row)
        print("CCCCCCC sourceIndexPath : \(sourceIndexPath) ,  destinationIndexPath : \(destinationIndexPath.row)")
        
        self.tempArray[destinationIndexPath.row].attributes.index = destinationIndexPath.row
        self.tempArray[sourceIndexPath.row].attributes.index = sourceIndexPath.row
        
//        todoService.shared.putDatainfo(id: tempArray[indexPath.row].id,//indexPath.row,
//                                       title: tempArray[indexPath.row].attributes.title,
//                                       isDone: tempArray[indexPath.row].attributes.isDone,
//                                       content: tempArray[indexPath.row].attributes.content,
//                                       completion: { (response) in
//            switch(response) {
//            case .success(let todoData):
//                print("Test")
//            case .requestErr(let message):
//                print("requestErr", message)
//            case .pathErr:
//                print("pathErr")
//            case .serverErr:
//                print("serverErr")
//            case .networkFail:
//                print("networkFail")
//            }
//        })
    }
    
}

//MARK: - 달력 컬렉션뷰 구현부
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // 섹션 개수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    // Cell 클릭 이벤트 함수
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("click index = \(indexPath.row)")
        let cell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
        switch indexPath.section {
        case 0:
            return
        default:
            if let didSelectedCell = oldCell {
                didSelectedCell.backgroundColor = .white
            }
            print("clicked")
            cell.backgroundColor = .systemGray5
            
            oldCell = cell
            
            dateComponent.day = Int(days[indexPath.row])
            let toastDate = cal.date(from: dateComponent)
            self.view.makeToast(toastFormatter.string(from: toastDate!), duration: 1.0)
        }
    }
    // 컬랙션 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            switch section {
            case 0:
                return self.weeks.count
            default:
                return self.days.count
            }
    }

    // 컨렉션 쎌 구성 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! MyCollectionViewCell
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
        
        var testComponent = DateComponents()
        testComponent.year = dateComponent.year
        testComponent.month = dateComponent.month
        testComponent.day = Int(days[indexPath.row])
        let testDate = cal.date(from: testComponent)

        if cal.isDateInToday(testDate!) {
            cell.backgroundColor = .systemGray5
            oldCell = cell
        } else {
            cell.backgroundColor = .white
        }
        
        return cell
    }
    
    // 컨렉션 쎌 간격/ 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let myBoundSize: CGFloat = UIScreen.main.bounds.size.width
        let cellSize: CGFloat = myBoundSize / 9
        return CGSize(width: cellSize, height: cellSize)
    }
}
