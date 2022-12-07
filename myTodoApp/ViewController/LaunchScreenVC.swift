//
//  LaunchScreenVC.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/12/07.
//

import Foundation
import UIKit

class LaunchScreenVC: UIViewController{
    
    @IBOutlet var logoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LaunchScreenVC - viewDidLoad() called")
        
        self.overrideUserInterfaceStyle = .light
    }
    
}
