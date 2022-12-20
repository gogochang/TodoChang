//
//  SideMenuVC.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/12/20.
//

import Foundation
import UIKit

class SideMenuVC: UIViewController {
    
    @IBOutlet var profileIcon: UIImageView!
    
    override func viewDidLoad() {
        print("SideMenuVC - viewDidLoad() called")
        super.viewDidLoad()
        
        self.initStyle()
    }
    
    private func initStyle() {
        profileIcon.layer.cornerRadius = 25
        profileIcon.layer.borderWidth = 0.5
    }
}
