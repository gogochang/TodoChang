//
//  LoadingService.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/12/15.
//

import Foundation
import UIKit

class LoadingService {
    
    static func showLoading() {
        
        DispatchQueue.main.async {
            
            //아래 윈도우는 최상단 윈도우
            guard let window = UIApplication.shared.windows.last else { return }
            
            
            let loadingIndicatorView: UIActivityIndicatorView
            
            //최상단에 이미 Indicator가 있는 경우 그대로 사용한다.
            if let existedView = window.subviews.first(
                where: {$0 is UIActivityIndicatorView} ) as? UIActivityIndicatorView {
                
                loadingIndicatorView = existedView
            } else { // 새로만들기
                
                loadingIndicatorView = UIActivityIndicatorView(style: .large)
                
                // 아래는 다른 UI를 클릭하는것을 방지한다.
                loadingIndicatorView.frame = window.frame
                loadingIndicatorView.color = .systemGray
                
                window.addSubview(loadingIndicatorView)
                
            }
            
            loadingIndicatorView.startAnimating()
        }
    }
    
    static func hideLoading() {
        
        DispatchQueue.main.async {
            
            guard let window = UIApplication.shared.windows.last else { return }
            
            window.subviews.filter({ $0 is UIActivityIndicatorView })
                .forEach { $0.removeFromSuperview()}
        }
    }
}


