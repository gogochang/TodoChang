//
//  todoDataModel.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/11/18.
//

import Foundation

struct todoDataModel: Codable {
    let data: [dataInfo]
}

struct dataInfo: Codable {
    let id: Int
    var attributes: data
}

struct data: Codable {
    var title: String
    var isDone: Bool
    let createdAt: String
    let updatedAt: String
    let publishedAt: String
    var content: String
    var index: Int
}
