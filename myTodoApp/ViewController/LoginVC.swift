//
//  LoginVC.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/12/12.
//

import Foundation
import UIKit
import Toast_Swift

class LoginVC: UIViewController {

    @IBOutlet var idText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var signInBtn: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initButtonStyle()
    }
    
    private func initButtonStyle() {
        //로그인 버튼
        // 모서리 둥근정도
        loginBtn.layer.cornerRadius = 12
        //그림자 투명도 (0 ~ 1)
        loginBtn.layer.shadowOpacity = 0.5
        //그림자 블러 (높을 수록 퍼지는 효과)
        loginBtn.layer.shadowRadius = 5
        //그림자 위치 ( 기본 0,0 -> 부모위치)
        loginBtn.layer.shadowOffset = CGSize(width: 1, height: 2)
        
        // 아이디 입력 텍스트창
        idText.placeholder = "이메일을 입력하세요."
        idText.layer.cornerRadius = 12
        idText.layer.shadowOpacity = 0.5
        idText.layer.shadowRadius = 5
        idText.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        // 패스워드 입력 텍스트창 디자인
        passwordText.placeholder = "비밀번호를 입력하세요."
        passwordText.layer.cornerRadius = 12
        passwordText.layer.shadowOpacity = 0.5
        passwordText.layer.shadowRadius = 5
        passwordText.layer.shadowOffset = CGSize(width: 1, height: 2)
    }
    
    //MARK: - 계정확인
    private func checkAccount(id: String?, password: String?) -> Bool {
        print("LoginVC - checkAcount() called")
        guard let ID = id else { return false }
        guard let PASSWORD = password else { return false }
        
        // ID와 Password 빈칸여부 확인
        if ID.isEmpty || PASSWORD.isEmpty {
            return false
        } else {
            //
            return true
        }
    }
    
    //MARK: - RootView를 변경하는 함수
    func changeRootViewController(_ viewControllerToPresent: UIViewController) {
           if let window = UIApplication.shared.windows.first {
               window.rootViewController = viewControllerToPresent
               UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
           } else {
               viewControllerToPresent.modalPresentationStyle = .overFullScreen
               self.present(viewControllerToPresent, animated: true, completion: nil)
           }
       }
    //MARK: - 로그인버튼
    @IBAction func clickedLoginBtn(sender: UIButton!) {
        print("LoginVC - clickedLoginBtn() called")
        self.modalTransitionStyle = .crossDissolve
        if checkAccount(id: idText.text, password: passwordText.text) {
            print("TA")
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let customPopUpVC = storyboard.instantiateViewController(withIdentifier: "MainVC") as! ViewController
            self.changeRootViewController(customPopUpVC)
            
        } else {
            self.view.makeToast("이메일 혹은 비밀번호를 확인해주세요.", duration: 1.0)
        }
    }
    
    @IBAction func clickedSignInBtn(sender: UIButton!) {
        print("LoginVC - clickedSignInBtn() called")
        // Sign in 버튼 클릭하면 회원가입하는 창 호출할 수 있도록 코드 입력
    }
}
