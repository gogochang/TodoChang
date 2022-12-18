//
//  CalendarScrollView.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/12/17.
//

import Foundation
import UIKit

class CalendarScrollView: BaseScrollView<[UICollectionView]> {
    
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
    
    override func bind(_ model: [UICollectionView]) {
        print("chang1")
        super.bind(model)
        print("chang2")
        setCalendar()
    }
    
    private func setCalendar() {
        guard let calendar = model else { return }
        print("chang3")
        calendar
            .enumerated()
            .forEach{
                print("chang4")
                let calendarCollectionView = $0
                print("chang5 -> \(calendarCollectionView)")
                let xOffset
            }
    }
//    private func setCalendar() {
//        guard let calendar = model else { return }
//        calendar
//            .enumerated()
//            .forEach {
//                //let collectionView = UICollectionView(coder: NSCoder)
//                let collectionView: UICollectionView = {
//                    let layout = UICollectionViewLayout()
//                    layout.scrollDirection = .horizontal
//                    layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//
//                    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//
//                    collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
////                            collectionView.register(CustomCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomCollectionHeaderView.identifier)
////                            collectionView.register(CustomCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CustomCollectionFooterView.identifier)
//                            return collectionView
//                }()
//
//                collectionView.contentMode = .scaleAspectFit
//                let xOffset = horizontalWidth * CGFloat($0.offset)
//
//                collectionView.frame = CGRect(x: xOffset, y:0, width: horizontalWidth, height: horizontalHeight)
//
//                addSubview(collectionView)
//            }
//    }
    
}

class CustomCollectionViewCell: UICollectionViewCell {
    
}
