//
//  SideMenuVC.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/12/20.
//

import Foundation
import UIKit

class SideMenuVC: UIViewController  {
    
    @IBOutlet var profileIcon: UIImageView!
    @IBOutlet var accountName: UILabel!
    @IBOutlet var accountEmail: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var name: String?
    var email: String?
    var todayDatainfo: [dataInfo]?
    var myTodayDatainfo: [dataInfo] = []
    
    override func viewDidLoad() {
        print("SideMenuVC - viewDidLoad() called")
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        initStyle()
        colanderTodayDatainfo()
        
        self.accountName.text = self.name
        self.accountEmail.text = self.email
    }
    
    private func initStyle() {
        profileIcon.layer.cornerRadius = 25
        profileIcon.layer.borderWidth = 0.5
    }
    
    private func colanderTodayDatainfo() {
        guard let dataInfoArray = todayDatainfo else { return }
        for i in 0 ..< dataInfoArray.count {
            if (dataInfoArray[i].attributes.UserName == name) {
                myTodayDatainfo.append(dataInfoArray[i])
            }
        }
    }
}

class SideMenuCell: UITableViewCell {
    @IBOutlet var sideMenuCellTitle: UILabel!
    @IBOutlet var sideMenuCellImageView: UIImageView!
}

extension SideMenuVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if myTodayDatainfo.count != 0 {
            return myTodayDatainfo.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as? SideMenuCell else { return UITableViewCell()}
        
        cell.selectionStyle = .none
        cell.sideMenuCellTitle.textColor = .black
        cell.sideMenuCellImageView.isHidden = true
    
        if myTodayDatainfo.count != 0 {
                cell.sideMenuCellTitle.text = myTodayDatainfo[indexPath.row].attributes.title
            if(myTodayDatainfo[indexPath.row].attributes.isDone) {
                cell.sideMenuCellImageView.isHidden = false
            }
        } else {
            cell.sideMenuCellTitle.text = "오늘 할 일을 작성해보세요."
            cell.sideMenuCellTitle.textColor = .systemGray2
        }
            return cell
    }
}
