//
//  SignUp.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/12/13.
//

import Foundation
import UIKit
import Toast_Swift
import Lottie


class SignUpVC: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkPasswordTextField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    
    var isDuplicate: Bool = false
    
    //Lottie Animation
    lazy var animationView: AnimationView = {
        let animationView = AnimationView.init(name: "75407-firecrackers-loading-screen")
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 0.9
        view.addSubview(animationView)
        return animationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SignUpVC - viewDidLoad() called")
        initStyle()
    }
    
    private func initStyle() {
        userNameTextField.placeholder = "닉네임을 입력하세요. 최대 10자"
        userNameTextField.layer.cornerRadius = 12
        userNameTextField.layer.shadowOpacity = 0.5
        userNameTextField.layer.shadowRadius = 5
        userNameTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        emailTextField.placeholder = "이메일을 입력하세요."
        emailTextField.layer.cornerRadius = 12
        emailTextField.layer.shadowOpacity = 0.5
        emailTextField.layer.shadowRadius = 5
        emailTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        passwordTextField.placeholder = "비밀번호를 입력하세요."
        passwordTextField.layer.cornerRadius = 12
        passwordTextField.layer.shadowOpacity = 0.5
        passwordTextField.layer.shadowRadius = 5
        passwordTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        checkPasswordTextField.placeholder = "비밀번호를 재입력하세요."
        checkPasswordTextField.layer.cornerRadius = 12
        checkPasswordTextField.layer.shadowOpacity = 0.5
        checkPasswordTextField.layer.shadowRadius = 5
        checkPasswordTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        registerBtn.layer.cornerRadius = 12
        registerBtn.layer.shadowOpacity = 0.5
        registerBtn.layer.shadowRadius = 5
        registerBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
    }

    @IBAction func clickedregisterBtn() {
        print("SignUpVC - clickedregisterBtn() called")
        checkUsersData()
    }
    
    @IBAction func clickedSignInBtn() {
        print("SignUpVC - clickedSignInBtn() called")
        self.dismiss(animated: true)
    }
}

//MARK: - API
extension SignUpVC {
    private func checkUsersData() {
        print("SignUpVC - getUsersData() called")
        signUpService.shared.getUsersData( completion: { response in
            switch(response) {
            case .success(let todoData):
                if let data = todoData as? [usersDataModel] {
                    guard let userName = self.userNameTextField.text else { return }
                    guard let email = self.emailTextField.text else { return }
                    guard let password = self.passwordTextField.text else { return }
                    guard let checkPassword = self.checkPasswordTextField.text else { return }
                    self.isDuplicate = false
                    
                    // 유저리스트중에 닉네임을 가져와 중복 확인
                    for i in 0 ..< data.count {
                        if self.userNameTextField.text == data[i].username {
                            self.view.makeToast("닉네임이 중복되었습니다.",duration: 1.0)
                            self.isDuplicate = true
                            return
                        }
                    }
                    // 닉네임 글자 수 체크
                    if userName.count > 10 {
                        self.view.makeToast("닉네임이 10자를 초과하였습니다.", duration: 1.0)
                        return
                    }
                    // email 형식 체크
                    if !email.contains("@") && !email.contains(".") {
                        self.view.makeToast("이메일 형식을 확인해주세요.", duration: 1.0)
                        return
                    }
                    // email 중복 체크
                    for i in 0 ..< data.count {
                        if self.emailTextField.text == data[i].email{
                            self.view.makeToast("이메일이 중복되었습니다.",duration: 1.0)
                            self.isDuplicate = true
                            return
                        }
                    }
                    // 비밀번호 재확인 체크
                    if password != checkPassword {
                        self.view.makeToast("비밀번호를 확인해주세요.", duration: 1.0)
                        return
                    }
                    self.registerUser(username: userName, email: email, password: password)
                    
                }
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr@")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
                
            }
        })
    }
    
    private func registerUser(username: String, email: String, password:String) {
        print("SignUpVC - registerUser() called")
        loginService.shared.registerUser(username: username, email: email, password: password, completion: {response in
            switch(response) {
            case .success(let todoData):
                print("chang 0> success - \(todoData)")
                self.view.makeToast("회원가입 완료!!", duration: 1.0)
                self.animationView.play(completion: { (result ) in
                    self.dismiss(animated: true)
                })
                
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        })
    }
}
