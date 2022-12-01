//
//  ViewController.swift
//  myTodoApp
//
//  Created by gogochang on 2022/11/16.
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
    
    var currentIndexPath: Int = 0
    var isClickedButtonName: String?
    var orderIndex: [Int] = []
    
    // 리스트 업데이트 할지 안할지
    
    var dataInfoDictionary: [Int: dataInfo] = [:]
    
    var isResetArray: Bool = true
    var addingArray: [dataInfo] = []
    var dataInfoArray: [dataInfo] = []
    {
        didSet{
            if isResetArray {
                print("tempArray - didset")
                getDatainfo()
                
                self.isResetArray = false
            }
            self.tableview.reloadData()
        }
    }
    
    var saveArray: [dataInfo] = []

    override func viewDidLoad() {
        print("ViewController - viewDidLoad() called")
        super.viewDidLoad()
        guard let tableview else { return }
        guard let countLabel else { return }
        
        //self.isResetArray = false
        getDatainfo()
        
        tableview.layer.cornerRadius = 15
        countLabel.text = "총 \(dataInfoArray.count) 개의 메모가 있습니다."
        
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
        getDatainfo()
        self.view.makeToast("아이템 목록이 리셋되었습니다", duration: 1.0)
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
                        index: dataInfoArray[indexPath.row].attributes.index)
        }
        self.view.makeToast("아이템이 수정되었습니다", duration: 1.0)
    }
}

//MARK: - 셀 뷰객체
class CustomCell: UITableViewCell {
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var UISwitch: UISwitch!
    var ofIndex: Int?
}

//MARK: - 리스트 테이블뷰 Cell 개수, Cell 구현부
extension ViewController: UITableViewDataSource,
                          UITableViewDelegate,
                          PopUpDelegate {
   
    // 테이블뷰의 갯수를 리턴해준다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("ViewController - tableview() called ")
        return dataInfoArray.count
    }
    
    // 테이블뷰 Cell의 형태를 구현하는 부분
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 인자로받은 tableView의 셀을 CustomCell로 캐스팅후 없으면 UITableViewCell의 기본클래스로 반환 아니면 다음줄 실행
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }

        saveArray.append(dataInfoArray[indexPath.row])
        
        cell.labelTitle.text = dataInfoArray[indexPath.row].attributes.title
        cell.UISwitch.isOn = dataInfoArray[indexPath.row].attributes.isDone
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
        //self.view.makeToast("아이템이 추가되었습니다", duration: 1.0)
        //가져온 데이터 타이틀이랑 내용 존재여부 확인 부분
        guard let title = title else { return }
        
        switch (isClickedButtonName) {
        // 테이블뷰 아이템 클릭
        case "tableView":
            print("ViewController - onDelegateEditButtonClicked() - tableView Switch called")
            // currentIndexPath에 저장된 클릭된 테이블뷰의 인덱스값을 가져와서
            // tempArray에 대응하는 title과 content에 대입.
            dataInfoArray[self.currentIndexPath].attributes.title = title
            
            // 테이블뷰 아이템 배열을 리셋하겠다. ( didSet의 내용을 실행하겠다. )
            self.isResetArray = true
            
            // PUT
            putDatainfo(id: dataInfoArray[self.currentIndexPath].id,
                        title: dataInfoArray[self.currentIndexPath].attributes.title,
                        isDone: dataInfoArray[self.currentIndexPath].attributes.isDone,
                        index: dataInfoArray[self.currentIndexPath].attributes.index)
            
            // Toast
            self.view.makeToast("아이템이 수정되었습니다", duration: 1.0)
        // 아이템 추가 버튼 클릭
        case "addButton":
            print("ViewController - onDelegateEditButtonClicked() - addButton Switch called")
            self.isResetArray = true
            
            // POST
            postDatainfo(title: title, isDone: false, index: self.dataInfoArray.count)
            self.view.makeToast("아이템이 추가되었습니다", duration: 1.0)
        case .none:
            break
        case .some(_):
            break
        }
    }
    
    //MARK: - PopUp Delete버튼 구현부
    func onDelegateDeleteButtonClicked() {
        print("ViewController - onDelegateDeleteButtonClicked() called")
        self.view.makeToast("아이템이 삭제되었습니다", duration: 1.0)
        self.isResetArray = true
        // method : "Delete"
        deleteDatainfo(id: dataInfoArray[self.currentIndexPath].id)
    }
}

//MARK: - Strapi에서 가져운 순서를 index순서대로 재비치를 해준다
extension ViewController {

    func resetIndex(_ array: [dataInfo]) -> [dataInfo] {
        print("ViewController - resetIndex() called")
        var changedArray: [dataInfo] = array
        print(array.count)
        for i in 0 ..< array.count {
            print("i = \(array[i])")
            changedArray[array[i].attributes.index] = array[i]
        }
        return changedArray
    }
    
    func resetDeletedIndex(_ array: [dataInfo]) -> [dataInfo] {
        print("ViewController - resetDeletedIndex() called")
        var changedArray: [dataInfo] = array
        var resultArray: [dataInfo] = []
        var sortedArray: [Int: dataInfo] = [:]
        
        // i번째 인덱스값을 키로, i번째 datainfo를 값으로,
        for i in 0 ..< array.count {
            sortedArray.updateValue(changedArray[i], forKey: changedArray[i].attributes.index)
        }
        
        // sortedArray의 키값으로 오름차순 정렬하여 실제로 사용하는 resultDic 딕셔너리에 저장
        let resultDic = sortedArray.sorted{ $0.0 < $1.0 }
        
        print("chang array.count => \(array.count), resultDic.count => \(resultDic.count)")
        // resultDic[i]번째의 값을 resultArray에 차례대로 넣는다.
        for i in 0 ..< array.count {
            resultArray.append(resultDic[i].value)
        }
        
        // 오름차순으로 resultArray를 정렬을 했는데 이게, 0145 띄어질수도 있거든?
        // 그래서 어차피 오름차순으로 되어있으니 0부터 차례대로 1씩 다시 재 정렬을 해주는거야
        // 그리고 정렬이 완료 되면, strapi에다가 다시 인덱스 값을 넣어줄거야.
        for i in 0 ..< resultArray.count {
            resultArray[i].attributes.index = i
            print("resultArray -> ", resultArray[i].id)
            
            putDatainfo(id: resultArray[i].id,
                        title: resultArray[i].attributes.title,
                        isDone: resultArray[i].attributes.isDone,
                        index: i)
        }
        
        return resultArray
    }

}

//MARK: - Strapi Comunication ( GET, PUT, POST, DELETE )
extension ViewController {
    
    //MARK: - Strapi GET
    private func getDatainfo() {
        todoService.shared.getDataInfo { (response) in
            switch(response) {
            case .success(let todoData):
                if let data = todoData as? [dataInfo] {
                    //self.tempArray = data
                    
                    var testArray: [dataInfo] = self.resetDeletedIndex(data)
                    
                    self.dataInfoArray = self.resetIndex(testArray)
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
    
    //MARK: - Strapi PUT
    private func putDatainfo(id: Int, title: String, isDone: Bool, index: Int) {
        todoService.shared.putDatainfo(id: id, title: title, isDone: isDone, index: index, completion: { (response) in
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
        //getDatainfo()
    }
    
    //MARK: Strapi POST
    private func postDatainfo(title: String, isDone: Bool, index: Int) {
        todoService.shared.postDatainfo(title: title, isDone: isDone, index: index, completion: { response in
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
        getDatainfo()
    }
    
    //MARK: - Strapi DELETE
    private func deleteDatainfo(id: Int) {
        print("Viewcontroller - deletedDatainfo() called")
        todoService.shared.deleteDatainfo(id: id, completion: { response in
            switch(response) {
            case .success(let todoData):
                if let data = todoData as? [dataInfo] {
                    print("success")
                } else {
                    print("fail")
                }
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("@pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        })
        getDatainfo()
    }
}

//MARK: - 달력 컬렉션뷰 구현부
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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

//MARK: - 테이블뷰 순서 바꾸기
extension ViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    // Drag
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
     
    //Drop
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {}
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 위치변화에 따라 index를 서로 교환해서 resetDeletedIndex에서 인덱스별로 순서를 재배치하도록 값을 변경함
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveCell = self.dataInfoArray[sourceIndexPath.row]
        var tempDatainfoIndex: Int
        tempDatainfoIndex = self.dataInfoArray[destinationIndexPath.row].attributes.index
        self.dataInfoArray[destinationIndexPath.row].attributes.index = self.dataInfoArray[sourceIndexPath.row].attributes.index
        self.dataInfoArray[sourceIndexPath.row].attributes.index = tempDatainfoIndex
        for i in 0 ..< self.dataInfoArray.count {
            print("self.dataInfoArray[i].attributes.index = ",self.dataInfoArray[i].attributes.index)
        }
        self.dataInfoArray = resetDeletedIndex(self.dataInfoArray)
    }
    
}
