//
//  todoService.swift
//  myTodoApp
//
//  Created by 김창규 on 2022/11/18.
//

import Foundation
import Alamofire

struct todoService {
    
    //싱글톤 패턴 적용
    static let shared = todoService()
    
    //MARK: - GET
    func getDataInfo(completion: @escaping (NetworkResult<Any>) -> Void) {
        
        let URL = "https://a088-180-226-219-117.jp.ngrok.io/api/todos"
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        // HTTP 통신 요청부분
        let dataRequest = AF.request(URL,
                                     method: .get,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        // 응답 데이터 처리부분
        dataRequest.responseData { dataResponse in
            // 응답데이터에 대한 결과를 스위치문으로 받는다.
            switch dataResponse.result {
            // 성공했따 하면 아래 코드 실행
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else { return }
                guard let value = dataResponse.value else { return }
                
                //print("Test1",statusCode)
                let networkResult = self.judgeStatus(by: statusCode, value)
                //print("Test2", networkResult)
                completion(networkResult)
            // 실패하면 .pathErr ~
            case .failure: completion(.pathErr)
            }
        }
    }
    
    //MARK: - MAKE Parameters
    private func makeParameter(title: String, isDone: Bool, index: Int) -> Parameters {
        return ["data": [ "title": title,
                          "isDone": isDone,
                          "index": index]]
    }
    
    //MARK: - POST
    func postDatainfo(title: String, isDone: Bool, index: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        let url = "https://a088-180-226-219-117.jp.ngrok.io/api/todos"
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: makeParameter(title: title, isDone: isDone, index: index),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        dataRequest.responseData{ dataResponse in
            //dump(dataResponse)
            print("postDaainfo closure")
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else { return }
                guard let value = dataResponse.value else { return }
                let networkResult = self.judgeStatus(by: statusCode, value)
                
            case .failure: completion(.pathErr)
            }
        }
    }
    
    //MARK: PUT
    func putDatainfo(id: Int, title: String, isDone: Bool, index: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        print("todoService - putDatainfo() called")
        
        let url = "https://a088-180-226-219-117.jp.ngrok.io/api/todos/" + String(id)
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        
        let dataRequest = AF.request(url,
                                     method: .put,
                                     parameters: makeParameter(title: title, isDone: isDone, index: index),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        dataRequest.responseData{ dataResponse in
            print("putDatainfo closure")
            //dump(dataResponse)
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else { return }
                guard let value = dataResponse.value else { return }
                let networkResult = self.judgeStatus(by: statusCode, value)

            case .failure: completion(.pathErr)
            }
        }
    }
    
    //MARK: Delete
    func deleteDatainfo(id: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        print("todoService - deleteDatainfo() called")
        
        let url = "https://a088-180-226-219-117.jp.ngrok.io/api/todos/" + String(id)
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        
        let dataRequest = AF.request(url,
                                     method: .delete,
                                     //parameters: makeParameter(title: title, isDone: isDone, content: content),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        dataRequest.responseData{ dataResponse in
            //dump(dataResponse)
            print("deleteDatainfo closure")
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else { return }
                guard let value = dataResponse.value else { return }
                let networkResult = self.judgeStatus(by: statusCode, value)
                
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
        print("todoService - isValidData() called ")
        let decoder = JSONDecoder()
        guard let decodeData = try? decoder.decode(todoDataModel.self, from: data) else { return .pathErr }
        return .success(decodeData.data)
    }
    
}
