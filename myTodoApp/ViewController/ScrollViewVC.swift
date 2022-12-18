//
//  ScrollViewVC.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/12/16.
//

import Foundation
import UIKit

class ScrollViewVC: UIViewController {
    
    lazy var horizontalScrollView: HorizontalScrollView = {
        let view = HorizontalScrollView(horizontalWidth: view.frame.width, horizontalHeight: view.frame.height)
        return view
    }()
    
    override func viewDidLoad() {
        print("ScrollViewVC - viewDidLoad() called")
        super.viewDidLoad()
        setupViews()
        addSubViews()
        makeConstraints()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        let image1 = UIImage(named: "image1")!
        let image2 = UIImage(named: "image2")!
        let image3 = UIImage(named: "image3")!
        
        horizontalScrollView.model = [image1, image2, image3]
        
    }
    
    func addSubViews() {
        view.addSubview(horizontalScrollView)
    }
    
    func makeConstraints() {
        horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            horizontalScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            horizontalScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            horizontalScrollView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
}
