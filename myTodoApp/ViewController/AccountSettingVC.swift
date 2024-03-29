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
//    @IBOutlet var profileSettingButton: UIButton!
//    @IBOutlet var emailChangeButton: UIButton!
//    @IBOutlet var passwordChangeButton: UIButton!
    @IBOutlet var logOutButton: UIButton!
    @IBOutlet var accountDeleteButton: UIButton!
    
    var idNum: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AccountSettingVC - viewDidLoad() called")
    }
    
    @IBAction func backButtonClicked() {
        print("AccountSettingVC - backButtonClicked() called")
        self.navigationController?.popViewController(animated: true)
    }
    
//    @IBAction func profileSettingButtonClicked(_ sender: UIButton) {
//        print("AccountSettingVC - profileSettingButtonClicked() called")
//        //TODO: profile 세팅화면으로 이동
//    }
//
//    @IBAction func emailChangeButtonClicked(_ sender: UIButton) {
//        print("AccountSettingVC - emailChangeButtonClicked() called")
//        //TODO: email 변경화면으로 이동
//    }
//
//    @IBAction func passwordChangeButtonClicked(_ sender: UIButton) {
//        print("AccountSettingVC - passwordChangedButtonClicked() called")
//        //TODO: password 변경화면으로 이동
//    }
    
    //MARK: - 로그아웃 클릭 함수
    @IBAction func logOutButtonClicked(_ sender: UIButton) {
        print("AccountSettingVC - logOutButtonClicked() called")
        let alret = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        let no = UIAlertAction(title: "No", style: .destructive, handler: nil)
        let yes = UIAlertAction(title: "Yes", style: .default) { [weak self] UIAlertAction in
            guard let self = self else { return }
            let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
            let LoginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            
            UserDefaults.standard.removeObject(forKey: "ID")
            UserDefaults.standard.removeObject(forKey: "PASSWORD")
            
            self.changeRootViewController(LoginVC)
        }
        
        alret.addAction(yes)
        alret.addAction(no)
        present(alret, animated: true, completion: nil)
    }
    
    //MARK: - 계정 삭제 버튼
    @IBAction func accountDeleteButtonClicked(_ sender: UIButton) {
        print("AccountSettingVC - accountDeleteButtonClicked() called")
        guard let id = idNum else {
            print("ID Number is nil")
            return }
        let alret = UIAlertController(title: "계정 삭제", message: "계정을 삭제하시겠습니까?", preferredStyle: .alert)
        let no = UIAlertAction(title: "No", style: .destructive, handler: nil)
        let yes = UIAlertAction(title: "Yes", style: .default) { UIAlertAction in
            accountService.shared.deleteUsers(id: id, completion: { [weak self] (response) in
                switch(response) {
                case .success:
                    print("success delete user")

                    guard let self = self else { return }
                    let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
                    let LoginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")

                    UserDefaults.standard.removeObject(forKey: "ID")
                    UserDefaults.standard.removeObject(forKey: "PASSWORD")

                    self.changeRootViewController(LoginVC)

                case .requestErr(let message):
                    print("requestErr", message)
                case .pathErr:
                    print("pathErr put")
                case .serverErr:
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
                }
            })
        }
        
        alret.addAction(yes)
        alret.addAction(no)
        present(alret, animated: true, completion: nil)
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
