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
    private let getAllGoodsPath = "/goods/get/all"
    
    func getAllGoods(completion: @escaping ((_ goods: [Good]) -> Void)) {
        
        guard let url = URL(string: host + getAllGoodsPath) else {
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
}
