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
import SwiftUI
import SnapKit

class SignUpVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkPasswordTextField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    
    @IBOutlet var userNameErrorText: UILabel!
    @IBOutlet var emailErrorText: UILabel!
    @IBOutlet var passwordErrorText: UILabel!
    @IBOutlet var checkPasswordErrorText: UILabel!
    
    var isPasses: [String: Bool] = ["username": false,
                                    "email": false,
                                    "password": false,
                                    "checkPassword": false]
    
    //Lottie Animation
    lazy var animationView: AnimationView = {
        let animationView = AnimationView.init(name: "75407-firecrackers-loading-screen")
        animationView.contentMode = .scaleAspectFill

        animationView.animationSpeed = 0.9
        view.addSubview(animationView)
        animationView.snp.makeConstraints{ make in
            make.centerY.equalTo(view).offset(-100)
            make.centerX.equalTo(view)
            make.width.equalTo(view.frame.width)
            make.height.equalTo(view.frame.width)
        }
        return animationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SignUpVC - viewDidLoad() called")
        self.overrideUserInterfaceStyle = .light
        hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        initStyle()
        
        self.userNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.checkPasswordTextField.delegate = self
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
        registerBtn.isEnabled = false
        registerBtn.backgroundColor = .systemGray5
        
        //Error Text
        userNameErrorText.isHidden = true
        emailErrorText.isHidden = true
        passwordErrorText.isHidden = true
        checkPasswordErrorText.isHidden = true
    }
    
    // 텍스트필드에서 리턴버튼 클릭하면
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch (textField) {
        case self.userNameTextField:
            self.emailTextField.becomeFirstResponder()
            
            return true
        case self.emailTextField:
            self.passwordTextField.becomeFirstResponder()
            return true
            
        case self.passwordTextField:
            self.checkPasswordTextField.becomeFirstResponder()
            return true
        case self.checkPasswordTextField:
            dismissKeyboard()
            return true
        default:
            print("clicked Return")
            return false
        }
        
    }

    //이메일 형식 검사
    func checkEmail(str: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return  NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: str)
    }
    
    // 텍스트필드 선택 해제
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("SignUpVC - textFieldDidEndEditing() called")
        
        getUsersData(textField)
    }

    // 회원등록 버튼
    @IBAction func clickedregisterBtn() {
        print("SignUpVC - clickedregisterBtn() called")
        guard let userName = self.userNameTextField.text else { return }
        guard let email = self.emailTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        
        LoadingService.showLoading()
        
        self.registerUser(username: userName,
                          email: email,
                          password: password)
    }
    
    // 로그인하러가는 버튼
    @IBAction func clickedSignInBtn() {
        print("SignUpVC - clickedSignInBtn() called")
        
        self.dismiss(animated: true)
    }
}

//MARK: - API
extension SignUpVC {
    private func getUsersData(_ textField: UITextField?) {
        print("SignUpVC - getUsersData() called")
        signUpService.shared.getUsersData( completion: { response in
            switch(response) {
            case .success(let todoData):
                if let data = todoData as? [usersDataModel] {
                    
                    guard let userName = self.userNameTextField.text else { return }
                    guard let email = self.emailTextField.text else { return }
                    guard let password = self.passwordTextField.text else { return }
                    guard let checkPassword = self.checkPasswordTextField.text else { return }
                    
                    
                    
                    // 유저리스트중에 닉네임을 가져와 중복 확인
                    
                    switch (textField) {
                    case self.userNameTextField:
                        print("self.userNameTextField")
                        if userName.count > 1 && userName.count < 11 {
                            self.isPasses["username"] = true
                            self.userNameErrorText.isHidden = true
                            for i in 0 ..< data.count {
                                if self.userNameTextField.text == data[i].username {
                                    self.userNameErrorText.text = "  이미 사용중인 이름입니다"
                                    self.userNameErrorText.isHidden = false
                                    self.isPasses["username"] = false
                                    //return
                                }
                            }
                        } else {
                            self.isPasses["username"] = false
                            self.userNameErrorText.text = "  2~10자의 닉네임만 사용 가능합니다."
                            self.userNameErrorText.isHidden = false
                            //return
                        }
                        
                    case self.emailTextField:
                        print("self.emailTextField")
                        if self.checkEmail(str: email) {
                            self.isPasses["email"] = true
                            self.emailErrorText.isHidden = true
                            // email 중복 체크
                            for i in 0 ..< data.count {
                                if self.emailTextField.text == data[i].email{
                                    self.isPasses["email"] = false
                                    self.emailErrorText.text = "  이미 사용중인 이메일입니다"
                                    self.emailErrorText.isHidden = false
                                    //return
                                }
                            }
                        } else {
                            self.isPasses["email"] = false
                            self.emailErrorText.text = "  이메일 형식이 잘못되었습니다."
                            self.emailErrorText.isHidden = false
                            //return
                        }
                        
                    case self.passwordTextField:
                        print("self.passwordTextField")
                        if password.count > 5 && password.count < 19 {
                            self.isPasses["password"] = true
                            self.passwordErrorText.isHidden = true
                        } else {
                            self.isPasses["password"] = false
                            self.passwordErrorText.isHidden = false
                            //return
                        }
                        
                        if password == checkPassword {
                            self.isPasses["checkPassword"] = true
                            self.checkPasswordErrorText.isHidden = true
                        } else {
                            self.isPasses["checkPassword"] = false
                            self.checkPasswordErrorText.isHidden = false
                            //return
                        }
                        
                    case self.checkPasswordTextField:
                        print("self.checkPasswordTextField")
                        if password == checkPassword {
                            self.isPasses["checkPassword"] = true
                            self.checkPasswordErrorText.isHidden = true
                        } else {
                            self.isPasses["checkPassword"] = false
                            self.checkPasswordErrorText.isHidden = false
                            //return
                        }
                    default:
                        print("clicked end Edit")
                    }
                    
                    print("Chang -> \(self.isPasses)")
                    if self.isPasses["username"] == true &&
                       self.isPasses["email"] == true &&
                       self.isPasses["password"] == true &&
                       self.isPasses["checkPassword"] == true {
                        self.registerBtn.backgroundColor = .black
                        self.registerBtn.isEnabled = true
                    } else {
                        self.registerBtn.backgroundColor = .systemGray5
                        self.registerBtn.isEnabled = false
                    }
                    
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
                LoadingService.hideLoading()
                self.animationView.play(completion: { (result ) in
                    self.dismiss(animated: true)
                })
                
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print("pathErr - register ")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        })
    }
}

extension SignUpVC {
    @objc func keyboardWillShow(notification: NSNotification) {
        print("SignUpVC - keyboardWillShow() called")
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
          // move the root view up by the distance of keyboard height
        self.view.frame.origin.y = 170 - keyboardSize.height
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        print("SignUpVC - keyboardWillHide() called")
        // move back the root view origin to zero
        self.view.frame.origin.y = 0
    }

    func hideKeyboardWhenTappedAround() {
        print("SignUpVC - hideKeyboardWhenTappedAround() called")
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        print("SignUpVC - dismissKeyboard() called")
        
        view.endEditing(true)
    }
}
