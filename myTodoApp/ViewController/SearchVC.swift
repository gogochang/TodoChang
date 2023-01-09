//
//  SearchVC.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/12/22.
//

import Foundation
import UIKit
import Combine

class SearchVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var allDataInfoArray: [dataInfo] = []
    var searchArray: [dataInfo] = []
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search.."
        return searchBar
    }()
    
    var mySubscription = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SearchVC - viewDidLoad() called ")
        
        // UI모양 초기화
        initStyle()
        
        // Publisher를 받는 부분
        searchBar.searchTextField.myDebounceSearchPublisher
            .sink { [weak self] (receiveValue) in
                guard let self = self else { return }
                
                self.searchArray.removeAll()
                for i in 0 ..< self.allDataInfoArray.count {
                    if self.allDataInfoArray[i].attributes.title.contains(receiveValue) {
                        self.searchArray.append(self.allDataInfoArray[i])
                    }
                }
                self.tableView.reloadData()
            }.store(in: &mySubscription)
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    private func initStyle() {
        // Navigation Search Bar
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.titleView = searchBar
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("SearchVC - viewDidDisappear() called")
        self.navigationController?.isNavigationBarHidden = true
    }
}

class SearchCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
}

//MARK: - TableView
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    // TableView item 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    // TableView Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchCell else {
            return UITableViewCell() }
        cell.titleLabel.text = searchArray[indexPath.row].attributes.title
        cell.dateLabel.text = searchArray[indexPath.row].attributes.date
        return cell
    }
     
    // TableView Cell Clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SearchVC - tableView Clicked() called")
        
        guard let vc = self.navigationController?.viewControllers.first as? ViewController else { return }
        vc.selectedDate = searchArray[indexPath.row].attributes.date
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: - Combine을 이용한 NotificationCenter Publisher 구현부
extension UISearchTextField {
    var myDebounceSearchPublisher : AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: self)
            .compactMap{ $0.object as? UISearchTextField }
            .map{ $0.text ?? "" }
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .filter{ $0.count > 0 }
            .print()
            .eraseToAnyPublisher()
    }
}
