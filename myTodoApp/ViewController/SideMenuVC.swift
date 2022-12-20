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
    
    var name: String?
    var email: String?
    
    override func viewDidLoad() {
        print("SideMenuVC - viewDidLoad() called")
        super.viewDidLoad()
        
        self.initStyle()
        
        self.accountName.text = self.name
        self.accountEmail.text = self.email
    }
    
    private func initStyle() {
        profileIcon.layer.cornerRadius = 25
        profileIcon.layer.borderWidth = 0.5
    }
}
