//
//  CustomPopUpViewController.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/11/20.
//

import UIKit

class CustomPopUpViewController: UIViewController {
    
    @IBOutlet weak var bgButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var textViewTitle: UITextView!
    
    var myPopUpDelegate: PopUpDelegate?
    
    var seletedItemTitle: String = ""
    var seletedItemContent: String = ""
    var clickedAddBtn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CustomPopUpViewController - viewDidLoad() called")
        
        // 테두리 둥글게
        contentView.layer.cornerRadius = 30
        editButton.layer.cornerRadius = 15
        deleteButton.layer.cornerRadius = 15
        editButton.layer.borderWidth = 1
        deleteButton.layer.borderWidth = 1
        
        // 텍스트입력창
        textViewTitle.text = self.seletedItemTitle
        textViewTitle.layer.borderWidth = 1
        textViewTitle.layer.borderColor = UIColor.black.cgColor
        
        if clickedAddBtn {
            deleteButton.isHidden = true
        } else {
            deleteButton.isHidden = false
        }
    }
    
    // 팝업창에서 검은 바탕화면 클릭하면 되돌아오는 기능버튼
    @IBAction func onBgButtonClicked(_ sender: UIButton) {
        print("CustomPopUpViewController - onBgButtonClicked() called")
        self.dismiss(animated: true)
    }
    
    @IBAction func onEditButtonClicked(_ sender: UIButton) {
        print("CustomPopUpViewController - onEditButtonClicked() called")
        
        self.dismiss(animated: true)
        myPopUpDelegate?.onDelegateEditButtonClicked(title: textViewTitle?.text)
    }
    
    @IBAction func onDeleteButtonClicked(_ sender: UIButton) {
        print("CustomPopUpViewController - onDeleteButtonClicked() called")
        self.dismiss(animated: true)
        myPopUpDelegate?.onDelegateDeleteButtonClicked()
    }
}
