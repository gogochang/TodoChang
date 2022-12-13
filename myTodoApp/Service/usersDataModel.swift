//
//  signDataModel.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/12/13.
//

import Foundation

struct usersDataModel: Codable {
    var id: Int
    var username: String
    var email: String
    var provider: String
    var confirmed: Bool
    var blocked: Bool
    var createdAt: String
    var updatedAt: String
}
