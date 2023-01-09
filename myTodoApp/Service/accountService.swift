//
//  accountService.swift
//  myTodoApp
//
//  Created by 김창규 on 2023/01/09.
//

import Foundation
import Alamofire

struct accountService {
    static let shared = accountService()
    
    func deleteUsers(id: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        print("accountService - deleteUser() called")
        let url = "https://clownfish-app-kr7st.ondigitalocean.app/api/users/" + String(id)
        let dataRequest = AF.request(url,
                                     method: .delete,
                                     parameters: nil,
                                     headers: nil)
        dataRequest.responseData{ dataResponse in
            //dump(dataResponse)
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else { return }
                guard let value = dataResponse.value else { return }
                
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
            case .failure: completion(.pathErr)
            }
        }
    }
    
    //MARK: - Status Code
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case 200:
            return isValidData(data: data)
        case 400:
            return .pathErr
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }

    //MARK: - Valid Test
    private func isValidData(data: Data) -> NetworkResult<Any> {
        print("signUpService - isValidData() called")
        let decoder = JSONDecoder()
        
        guard let decodeData = try? decoder.decode(usersDataModel.self, from: data) else { return .pathErr }
        return .success(decodeData)
    }
}
