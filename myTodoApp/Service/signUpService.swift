//
//  signUpService.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/12/13.
//

import Foundation
import Alamofire

struct signUpService {
    
    static let shared = signUpService()
    
    //MARK: - Get Users
    func getUsersData(completion: @escaping (NetworkResult<Any>) -> Void) {
        print("signUpService - getUsersData() called")
        let url = "https://shark-app-kofkm.ondigitalocean.app/api/users"
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        let dataRequest = AF.request(url,
                                     method: .get,
                                     encoding: JSONEncoding.default,
                                     headers: header)
    
        dataRequest.responseData { dataResponse in
            dump(dataResponse)
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
            print("statuscode 200")
            return isValidData(data: data)
        case 400:
            print("statuscode 400")
            return .pathErr
        case 500:
            print("statuscode 500")
            return .serverErr
        default:
            print("networkFail")
            return .networkFail
        }
    }

    //MARK: - Valid Test
    private func isValidData(data: Data) -> NetworkResult<Any> {
        print("signUpService - isValidData() called")
        let decoder = JSONDecoder()
        
        guard let decodeData = try? decoder.decode([usersDataModel].self, from: data) else { return .pathErr }
        return .success(decodeData)
    }
    
}
