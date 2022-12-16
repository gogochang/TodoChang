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
    var index: Int
    var date: String
    let UserName: String
}

//
//dataInfo(id: 135,
//         attributes:
//            myTodoApp.data(
//                title: "Api 콤바인 영상 까지 보기",
//                isDone: false,
//                createdAt: "2022-12-09T10:54:59.358Z",
//                updatedAt: "2022-12-16T08:07:27.861Z",
//                publishedAt: "2022-12-09T10:54:59.356Z",
//                index: 1,
//                date: "2022-12-09"))
