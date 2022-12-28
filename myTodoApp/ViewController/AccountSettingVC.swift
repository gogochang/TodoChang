//
//  AccountSettingVC.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/12/25.
//

import Foundation
import UIKit

class AccountSettingVC: UIViewController {
    
    @IBOutlet var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AccountSettingVC - viewDidLoad() called")
    }
    
    @IBAction func backButtonClicked() {
        print("AccountSettingVC - backButtonClicked() called")
        
        self.navigationController?.popViewController(animated: true)
    }
}
