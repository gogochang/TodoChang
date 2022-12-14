//
//  KeyboardEvader.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/12/13.
//

import Foundation
import UIKit

protocol KeyboardEvader where Self: UIViewController {
   var keyboardScrollView: UIScrollView { get }
   func registerForKeyboardNotification()
 }
 extension KeyboardEvader where Self: UIViewController {
   func registerForKeyboardNotification() {
     NotificationCenter.default.addObserver(
       forName: UIResponder.keyboardWillShowNotification,
       object: nil,
       queue: OperationQueue.main
     ) { [weak self] notification in
       self?.keyboardWillShow(notification: notification)
     }
     NotificationCenter.default.addObserver(
       forName: UIResponder.keyboardWillHideNotification,
       object: nil,
       queue: OperationQueue.main
     ) { [weak self] notification in
       self?.keyboardWillHide(notification: notification)
     }
   }
 private func keyboardWillShow(notification: Notification) {
     guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
       assertionFailure("Couldn't get keyboard frame.")
       return
     }
     let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
     keyboardScrollView.contentInset = insets
     keyboardScrollView.scrollIndicatorInsets = insets
   }
 private func keyboardWillHide(notification: Notification) {
     keyboardScrollView.contentInset = .zero
     keyboardScrollView.scrollIndicatorInsets = .zero
   }
 }
