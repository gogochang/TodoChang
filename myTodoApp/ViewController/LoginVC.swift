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

    var testnumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("LoginVC - viewDidload() called")
        autoLogin()
        self.overrideUserInterfaceStyle = .light
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
    //MARK: - 로그인 버튼 클릭 이벤트
    @IBAction func clickedLoginBtn(sender: UIButton!) {
        print("LoginVC - clickedLoginBtn() called")
        LoadingService.showLoading()
        self.modalTransitionStyle = .crossDissolve
        if checkAccount(id: idText.text, password: passwordText.text) {
            guard let id = idText.text else { return }
            guard let password = passwordText.text else { return }
            
            
            
            checkLoginData(id: id, password: password)
            
            
        } else {
            LoadingService.hideLoading()
            self.view.makeToast("이메일 혹은 비밀번호를 확인해주세요.", duration: 1.0)
        }
    }
    
    //MARK: - 회원가입 버튼 클릭 이벤트
    @IBAction func clickedSignInBtn(sender: UIButton!) {
        print("LoginVC - clickedSignInBtn() called")
        
        let storyboard = UIStoryboard.init(name: "SignUp", bundle: nil)
        let SignUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpVC")
        SignUpVC.modalTransitionStyle = .coverVertical
        SignUpVC.modalPresentationStyle = .automatic
        self.present(SignUpVC, animated: true, completion: nil)
        
    }
    
    private func checkLoginData(id: String, password: String) {
        print("LoginVC - postLoginData() called, ID: \(id), PASSWORD: \(password)")
        loginService.shared.postLoginData(id: id, password: password, completion: { response in
            switch(response) {
            case .success(let todoData):
                if let data = todoData as? loginDataModel {
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    //let MainVC = storyboard.instantiateViewController(withIdentifier: "MainVC") as! ViewController
                    let MainNav = storyboard.instantiateViewController(withIdentifier: "MainNavigationView") as! MainNavigationView
                    // 메인뷰컨트롤에 로그인한 유저네임 넘기기
                    let MainVC = MainNav.viewControllers.first as! ViewController
                    
                    LoadingService.hideLoading()
                    // 메인뷰컨트롤에 로그인한 유저네임 넘기기
                    MainVC.username = data.user.username
                    MainVC.email = data.user.email
                    MainVC.idNum = data.user.id
                    
                    UserDefaults.standard.set(data.user.username, forKey: "ID")
                    UserDefaults.standard.set(data.user.email, forKey: "PASSWORD")
                    UserDefaults.standard.set(data.user.id, forKey: "IDNUMBER")
                    
                    self.changeRootViewController(MainNav)
                    self.view.makeToast("로그인", duration: 1.0)
                    
                }
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr")
                LoadingService.hideLoading()
                self.view.makeToast("아이디 또는 비밀번호를 잘못 입력했습니다.", duration: 1.0)
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        })
    }
    
    private func autoLogin() {
        
        guard let id = UserDefaults.standard.string(forKey: "ID") else {return}
        guard let password = UserDefaults.standard.string(forKey: "PASSWORD") else { return }
        guard let username = UserDefaults.standard.string(forKey: "USERNAME") else { return }
        guard let idNum = UserDefaults.standard.integer(forKey: "IDNUMBER") as Int? else { return }
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let MainNav = storyboard.instantiateViewController(withIdentifier: "MainNavigationView") as! MainNavigationView
        // 메인뷰컨트롤에 로그인한 유저네임 넘기기
        let MainVC = MainNav.viewControllers.first as! ViewController
        MainVC.username = username
        MainVC.email = id
        MainVC.idNum = idNum
        
        self.changeRootViewController(MainNav)
        self.view.makeToast("로그인", duration: 1.0)
        LoadingService.hideLoading()
        
    }
}

//MARK: - Keyboard
extension LoginVC {
    @objc func keyboardWillShow(notification: NSNotification) {
                
            guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
               // if keyboard size is not available for some reason, dont do anything
               return
            }
          
          // move the root view up by the distance of keyboard height
          self.view.frame.origin.y = 120 - keyboardSize.height
        }

        @objc func keyboardWillHide(notification: NSNotification) {
          // move back the root view origin to zero
          self.view.frame.origin.y = 0
        }

    func hideKeyboardWhenTappedAround() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
}
