//
//  NetworkService.swift
//  ShopyApp
//
//  Created by sayed mansour on 04/09/2024.
//

import Foundation
import Alamofire

class NetworkManager{

   static let manager = NetworkManager()


    func fetchData <T: Codable>(url: String, type: T.Type, complitionHandler: @escaping (T?)->Void, headers: HTTPHeaders = [:]) {
        let url = URL(string:url)
        guard let newURL = url else {
            complitionHandler(nil)
            return  }
        
        AF.request(newURL, method: .get, headers: headers).response { data in
            guard let data = data.data else {
                complitionHandler(nil)
                return  }
            print("fetching in background")
            do{
                let result = try JSONDecoder().decode(T.self, from: data)
                complitionHandler(result)
            }catch let error{
                print("the error is in the decoding proccess")
                print(error.localizedDescription)
                complitionHandler(nil)
            }
        }
    }
    
    func postWithResponse<T:Codable>(url:String,type: T.Type,parameters: Parameters,completion: @escaping ((T?)->Void)){
        let headers: HTTPHeaders = [
            "Cookie":"",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let url = URL(string:url)
        guard let newURL = url else {
            return
        }
        AF.request(newURL, method: .post, parameters: parameters, encoding: JSONEncoding.default , headers: headers)/*.validate(statusCode: 200..<300)*/
            .response{ response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        //
                        print("Success:\(String(data: data, encoding: .utf8) ?? "") ")
                        do{
                            let result = try JSONDecoder().decode(T.self, from: data)
                            completion(result)
                        }catch let error{
                            print("the error is in the decoding proccess")
                            print(error)
                            completion(nil)
                        }
                        
                    }
                case .failure(let error):
                    print("Error: \(error)")
                    
                    print(error)
                    completion(nil)
                    if let data = response.data {
                        print("Response Data: \(String(data: data, encoding: .utf8) ?? "")")
                    }
                }
            }
    }
    
    func PostToApi(url:String,parameters: Parameters){
        let headers: HTTPHeaders = ["Cookie":""]
        let url = URL(string:url)
        guard let newURL = url else {
            return
        }
        AF.request(newURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response{ response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        print("Success: \(String(data: data, encoding: .utf8) ?? "")")
                    }
                case .failure(let error):
                    print("Error: \(error)")
                    
                    if let data = response.data {
                        print("Response Data: \(String(data: data, encoding: .utf8) ?? "")")
                    }
                }
            }
    }
    
    func putInApi(url:String, parameters: Parameters = [:]){
        
        let headers: HTTPHeaders = ["Cookie":""]
        let url = URL(string:url)
        guard let newURL = url else {
            return
        }
        AF.request(newURL, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response{ response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        print("Success: \(String(data: data, encoding: .utf8) ?? "")")
                    }
                case .failure(let error):
                    print("Error: \(error)")
                    
                    if let data = response.data {
                        print("Response Data: \(String(data: data, encoding: .utf8) ?? "")")
                    }
                }
            }
    }
    
    func deleteFromApi(url:String){
        let headers: HTTPHeaders = ["Cookie":""]
        AF.request(url, method: .delete,headers: headers)
            .response { response in
                if let error = response.error {
                    print("Error deleting item: \(error)")
                } else {
                    if let data = response.data {
                        print("Success: \(String(data: data, encoding: .utf8) ?? "")")
                    }
                    print("Item deleted successfully")
                }
            }
    }
}
