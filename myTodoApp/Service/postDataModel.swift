//
//  postDataModel.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/12/16.
//

import Foundation

struct postDataModel: Codable {
    let data: postDataInfo
    let meta : metaData
}

struct postDataInfo: Codable {
    let id: Int
    var attributes: postData
}

struct postData: Codable {
    let title: String
    let isDone: Bool
    let index: Int
    let date: String
    let createdAt: String
    let updatedAt: String
    let publishedAt: String
    let UserName: String
}

struct metaData: Codable {
    
}
