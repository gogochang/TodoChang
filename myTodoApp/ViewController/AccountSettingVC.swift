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
    @IBOutlet var profileSettingButton: UIButton!
    @IBOutlet var emailChangeButton: UIButton!
    @IBOutlet var passwordChangeButton: UIButton!
    @IBOutlet var logOutButton: UIButton!
    @IBOutlet var accountDeleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AccountSettingVC - viewDidLoad() called")
    }
    
    @IBAction func backButtonClicked() {
        print("AccountSettingVC - backButtonClicked() called")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func profileSettingButtonClicked(_ sender: UIButton) {
        print("AccountSettingVC - profileSettingButtonClicked() called")
        //TODO: profile 세팅화면으로 이동
    }
    
    @IBAction func emailChangeButtonClicked(_ sender: UIButton) {
        print("AccountSettingVC - emailChangeButtonClicked() called")
        //TODO: email 변경화면으로 이동
    }
    
    @IBAction func passwordChangeButtonClicked(_ sender: UIButton) {
        print("AccountSettingVC - passwordChangedButtonClicked() called")
        //TODO: password 변경화면으로 이동
    }
    
    //로그아웃 클릭 함수
    @IBAction func logOutButtonClicked(_ sender: UIButton) {
        print("AccountSettingVC - logOutButtonClicked() called")
        
        let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
        let LoginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        
        UserDefaults.standard.removeObject(forKey: "ID")
        UserDefaults.standard.removeObject(forKey: "PASSWORD")
        
        changeRootViewController(LoginVC)
    }
    
    @IBAction func accountDeleteButtonClicked(_ sender: UIButton) {
        print("AccountSettingVC - accountDeleteButtonClicked() called")
        //TODO: 계정 삭제
    }
    
    // Rootview 변경함수 코드정리필요
    func changeRootViewController(_ viewControllerToPresent: UIViewController) {
           if let window = UIApplication.shared.windows.first {
               window.rootViewController = viewControllerToPresent
               UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
           } else {
               viewControllerToPresent.modalPresentationStyle = .overFullScreen
               self.present(viewControllerToPresent, animated: true, completion: nil)
           }
    }
}
