//
//  BaseScrollView.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/12/17.
//

import Foundation
import UIKit

//BaseScrollView 정의
class BaseScrollView<Model>: UIScrollView {
    
    var model: Model? {
        didSet{
            if let model = model {
                print("chang5")
                bind(model)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {}
    func bind(_ model: Model) {}
}
