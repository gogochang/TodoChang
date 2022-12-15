//
//  ActivityIndicator.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/12/15.
//


import SwiftUI

struct ActivityIndicator: View {
    
    @State var currentDegrees = 0.0

    var body: some View {
        Text("Hello SwiftUI")
    }
//    var body: some View {
//        Circle()
//            .trim(from: 0.0, to: 0.8)
//            .stroke(lineWidth: 5)
//            .frame(width: 60, height: 60)
//            .rotationEffect(Angle(degrees: currentDegrees))
//            .onAppear(perform: {
//                Timer.scheduledTimer(withTimeInterval: 0.05,
//                                     repeats: true,
//                                     block: { _ in
//                    withAnimation{self.currentDegrees += 10}
//                })
//            })
//    }
}


#if DEBUG
import SwiftUI
struct ActivityIndicator_Previews: UIVIewCon {
    static var previews: some View {
        ActivityIndicator()
    }
}
#endif
