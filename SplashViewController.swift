//
//  SplashScreen.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/12/04.
//

import Foundation
import Lottie
import UIKit

class SplashViewController: UIViewController {
    
    
    @IBOutlet var splashText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.splashText.alpha = 0
        //UIView.animate(withDuration: 1.0, animations: <#T##() -> Void#>)
    }
}
