//
//  MainNavigationView.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/12/24.
//

import Foundation
import UIKit

class MainNavigationView: UINavigationController {

    static let shared = MainNavigationView()
    
    // LoginVC에서 가져오는 계정 정보 데이터
    var username: String?
    var email: String?
    var password: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MainNavigationView - viewDidLoad() called")
    }

}
