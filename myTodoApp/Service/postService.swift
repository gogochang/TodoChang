//
//  postService.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/12/16.
//

import Foundation
import Alamofire

struct postService {
    
    static let shared = postService()
    
    //MARK: - MAKE Parameters
    private func makeParameter(title: String, isDone: Bool, index: Int, date: String) -> Parameters {
        return ["data": [ "title": title,
                          "isDone": isDone,
                          "index": index,
                          "date": date]]
    }
    
    //MARK: - POST
    func postDatainfo(title: String, isDone: Bool, index: Int, date: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = "https://clownfish-app-kr7st.ondigitalocean.app/api/todos"
        
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: makeParameter(title: title, isDone: isDone, index: index, date: date),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        dataRequest.responseData{ dataResponse in
            //dump(dataResponse)
            print("postDaainfo 2closure")
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else { return }
                guard let value = dataResponse.value else { return }
                let networkResult = self.judgeStatus(by: statusCode, value)
                print("todoService - 2postDatainfo() success")
                completion(networkResult)
            case .failure: completion(.pathErr)
            }
            print("todoService - 2postDatainfo() called")
        }
    }
    
    //MARK: PUT
    func putDatainfo(id: Int, title: String, isDone: Bool, index: Int, date: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        print("postService - putDatainfo() called")
        
        let url = "https://clownfish-app-kr7st.ondigitalocean.app/api/todos/" + String(id)
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        
        let dataRequest = AF.request(url,
                                     method: .put,
                                     parameters: makeParameter(title: title, isDone: isDone, index: index, date: date),
                                     encoding: JSONEncoding.default,
                                     headers: header)
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
    
    //MARK: Delete
    func deleteDatainfo(id: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        print("todoService - deleteDatainfo() called id = \(String(id))")
        
        let url = "https://clownfish-app-kr7st.ondigitalocean.app/api/todos/" + String(id)
        
        let dataRequest = AF.request(url,
                                     method: .delete,
                                     parameters: nil,
                                     headers: nil)
        dataRequest.responseData{ dataResponse in
            //dump(dataResponse)
            print("deleteDatainfo closure")
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else { return }
                guard let value = dataResponse.value else { return }

                let networkResult = self.judgeStatus(by: statusCode, value)
                print("todoService - deleteDatainfo() success")
                completion(networkResult)
            case .failure: completion(.pathErr)
            }
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
        //print("todoService - isValidData() called ")
        let decoder = JSONDecoder()
        guard let decodeData = try? decoder.decode(postDataModel.self, from: data) else { return .pathErr }
        return .success(decodeData.data)
    }
}
