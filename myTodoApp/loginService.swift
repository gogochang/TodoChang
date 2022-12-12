//
//  loginService.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/12/13.
//

import Foundation
import Alamofire

struct loginService {
    
    static let shared = loginService()
    
    //MARK: - Login
    private func makeParameter(id: String, password: String) -> Parameters {
        return ["identifier": id,
                "password": password]
    }

    
    func postLoginData(id: String, password: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        print("todoService - postLoginData() called")
        
        let url = "https://clownfish-app-kr7st.ondigitalocean.app/api/auth/local"
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: makeParameter(id: id, password: password),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData{ dataResponse in
            dump(dataResponse)
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else { return }
                guard let value = dataResponse.value else { return }
                
                let networkResult = self.judgeStatus(by: statusCode, value)
                //print("chang@@ -> \(completion(.success(res)))")
                //completion(.success(value))
                completion(networkResult)
            case .failure: completion(.pathErr)
            }
            print("todoService - postLoginData() called")
        }
    }
    //MARK: - Status Code
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case 200:
            //print("statuscode 200")
            return isValidData(data: data)
        case 400:
            //print("statuscode 400")
            return .pathErr
        case 500:
            //print("statuscode 500")
            return .serverErr
        default:
            //print("networkFail")
            return .networkFail
        }
    }

    //MARK: - Valid Test
    private func isValidData(data: Data) -> NetworkResult<Any> {
        print("loginService - isValidData() called \(todoDataModel.self) ")
        let decoder = JSONDecoder()
        
        guard let decodeData = try? decoder.decode(loginDataModel.self, from: data) else { return .pathErr }
        print("loginService - isValidData() called \(decodeData) ")
        return .success(decodeData)
    }
    
}
