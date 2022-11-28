//
//  PopUpDelegate.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/11/20.
//

import Foundation

protocol PopUpDelegate {
    func onDelegateEditButtonClicked(title: String?)
    func onDelegateDeleteButtonClicked()
}
