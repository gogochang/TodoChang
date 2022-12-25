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
    
    override func viewDidLoad() {
        print("SideMenuVC - viewDidLoad() called")
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.initStyle()
        
        self.accountName.text = self.name
        self.accountEmail.text = self.email
        
    }
    
    private func initStyle() {
        profileIcon.layer.cornerRadius = 25
        profileIcon.layer.borderWidth = 0.5
    }
}

class SideMenuCell: UITableViewCell {
    @IBOutlet var sideMenuCellTitle: UILabel!
    @IBOutlet var sideMenuCellImageView: UIImageView!
}

extension SideMenuVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if todayDatainfo!.count != 0 {
            return todayDatainfo!.count
        } else {
            return 1
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as? SideMenuCell else { return UITableViewCell()}
        
        cell.selectionStyle = .none
        cell.sideMenuCellTitle.textColor = .black
        cell.sideMenuCellImageView.isHidden = true
        
        if todayDatainfo!.count != 0 {
            cell.sideMenuCellTitle.text = todayDatainfo![indexPath.row].attributes.title
            
            if(todayDatainfo![indexPath.row].attributes.isDone) {
                cell.sideMenuCellImageView.isHidden = false
            }
        } else {
            cell.sideMenuCellTitle.text = "오늘 할 일을 작성해보세요."
            cell.sideMenuCellTitle.textColor = .systemGray2
        }
            return cell
        
    }
    
    
}
