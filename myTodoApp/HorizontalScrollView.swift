//
//  HorizontalScrollView.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/12/17.
//

import Foundation
import UIKit

class HorizontalScrollView: BaseScrollView<[UIImage]> {
    
    let horizontalWidth: CGFloat
    let horizontalHeight: CGFloat
    
    init(horizontalWidth: CGFloat, horizontalHeight: CGFloat) {
        self.horizontalWidth = horizontalWidth
        self.horizontalHeight = horizontalHeight
        
        super.init(frame: .zero)
        
        configure()
    }
    
    override func configure() {
        super.configure()
        
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
    }
    
    override func bind(_ model: [UIImage]){
        print("chang1")
        //super.bind(model)
        print("chang2")
        setImages()
        print("chang3")
        updateScrollViewContentWidth()
        print("chang4")
    }
    
    private func setImages() {
        guard let images = model else { return }
        images
            .enumerated()
            .forEach{
                print("chang8 ", $0.element)
                let imageView = UIImageView(image: $0.element)
                
                imageView.contentMode = .scaleAspectFit
                
                let xOffset = horizontalWidth * CGFloat($0.offset)
                
                imageView.frame = CGRect(x: xOffset, y:0, width: horizontalWidth, height: horizontalHeight)
                
                addSubview(imageView)
            }
    }
    
    private func updateScrollViewContentWidth() {
        contentSize.width = horizontalWidth * CGFloat(model?.count ?? 1 )
    }
}
