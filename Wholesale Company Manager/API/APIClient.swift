//
//  APIClient.swift
//  Wholesale Company Manager
//
//  Created by panandafog on 10.04.2021.
//

import Alamofire
import Foundation

class APIClient {
    
    private let host = "http://localhost:8080"
    private let goodsPath = "/goods"
    private let salesPath = "/sales"
    private let smallWarehousePath = "/warehouse1"
    private let bigWarehousePath = "/warehouse2"
    private let getAllPath = "/get/all"
    private let savePath = "/save"
    private let deleteByIdPath = "/delete/by/id"
    
    // MARK: - getAllGoods
    func getAllGoods(completion: @escaping ((_ goods: [Good]) -> Void)) {
        
        guard let url = URL(string: host + goodsPath + getAllPath) else {
            return
        }
        let request = AF.request(url)
        
        request.responseJSON(completionHandler: { json in
            guard let data = json.data else {
                return
            }
            guard let goods = try? JSONDecoder().decode([Good].self, from: data) else {
                return
            }
            completion(goods)
        })
    }
    
    // MARK: saveGood
    func saveGood(_ good: Good, completion: (() -> Void)?) {
        
        guard let url = URL(string: host + goodsPath + savePath) else {
            return
        }
        let encoder = JSONEncoder()
        
        guard let jsonData = try? encoder.encode(good) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        AF.request(request).responseJSON { response in
            switch response.result {
            case .success(let value):
                print ("finish")
                if completion != nil {
                    completion!()
                }
            case .failure(let error):
                print ("error")
            }
        }
    }
    
    // MARK: deleteGood
    func deleteGood(id: Int, completion: (() -> Void)?) {
        
        let parameters: [String: Any] = [
            "id" : id
        ]
        
        guard let url = URL(string: host + goodsPath + deleteByIdPath) else {
            return
        }
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON (completionHandler: { result in
            
            if completion != nil {
                completion!()
            }
        })
    }
}
