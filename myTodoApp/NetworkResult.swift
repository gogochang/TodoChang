//
//  NetworkResult.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/11/18.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}
