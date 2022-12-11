//
//  LoginVC.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/12/12.
//

import Foundation
import UIKit

class LoginVC: UIViewController {

    @IBOutlet var idText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var signInBtn: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBtn.layer.cornerRadius = 15
    }
    
    @IBAction func clickedLoginBtn(sender: UIButton!) {
        print("LoginVC - clickedLoginBtn() called")
        // 로그인 버튼 클릭하면
        // 이메일, 패스워드가 맞는 정보가
        // 있다 -> 메인VC 호출
        // 없다 -> 정보가 잘못되었다 에러메시지 출력
        
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let customPopUpVC = storyboard.instantiateViewController(withIdentifier: "MainVC") as! ViewController
        // 뷰컨트롤러가 보여지는 스타일
        customPopUpVC.modalPresentationStyle = .overCurrentContext
        // 뷰컨트롤러가 사라지는 스타일
        customPopUpVC.modalTransitionStyle = .crossDissolve
        //customPopUpVC.myPopUpDelegate = self
        //customPopUpVC.clickedAddBtn = true
        //현재 VC위에 customPopVC를 보여준다. animation 효과 , 해당액션은 nil
        self.present(customPopUpVC, animated: true, completion: nil)
        
    }
    
    @IBAction func clickedSignInBtn(sender: UIButton!) {
        print("LoginVC - clickedSignInBtn() called")
        // Sign in 버튼 클릭하면 회원가입하는 창 호출할 수 있도록 코드 입력
    }
}
