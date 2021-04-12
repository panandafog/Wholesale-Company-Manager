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
    
    // MARK: - getAllSales
    func getAllSales(completion: @escaping ((_ sales: [Sale]) -> Void)) {
        
        guard let url = URL(string: host + salesPath + getAllPath) else {
            return
        }
        let request = AF.request(url)
        
        request.responseJSON(completionHandler: { json in
            guard let data = json.data else {
                return
            }
            guard let sales = try? JSONDecoder().decode([Sale].self, from: data) else {
                return
            }
            completion(sales)
        })
    }
    
    // MARK: saveSale
    func saveSale(_ sale: Sale, completion: (() -> Void)?) {
        
        guard let url = URL(string: host + salesPath + savePath) else {
            return
        }
        let encoder = JSONEncoder()
        
        guard let jsonData = try? encoder.encode(sale) else {
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
    
    // MARK: deleteSale
    func deleteSale(id: Int, completion: (() -> Void)?) {
        
        let parameters: [String: Any] = [
            "id" : id
        ]
        
        guard let url = URL(string: host + salesPath + deleteByIdPath) else {
            return
        }
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON (completionHandler: { result in
            
            if completion != nil {
                completion!()
            }
        })
    }
    
    // MARK: - getAllRacks
    func getAllRacks(warehouse: Warehouse, completion: @escaping ((_ racks: [Rack]) -> Void)) {
        
        guard let url = URL(string: host + warehouse.path() + getAllPath) else {
            return
        }
        let request = AF.request(url)
        
        request.responseJSON(completionHandler: { json in
            guard let data = json.data else {
                return
            }
            guard let racks = try? JSONDecoder().decode([Rack].self, from: data) else {
                return
            }
            completion(racks)
        })
    }
    
    // MARK: saveRack
    func saveRack(_ rack: Rack, warehouse: Warehouse, completion: (() -> Void)?) {
        
        guard let url = URL(string: host + warehouse.path() + savePath) else {
            return
        }
        let encoder = JSONEncoder()
        
        guard let jsonData = try? encoder.encode(rack) else {
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
    
    // MARK: deleteRack
    func deleteRack(id: Int, warehouse: Warehouse, completion: (() -> Void)?) {
        
        let parameters: [String: Any] = [
            "id" : id
        ]
        
        guard let url = URL(string: host + warehouse.path() + deleteByIdPath) else {
            return
        }
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON (completionHandler: { result in
            
            if completion != nil {
                completion!()
            }
        })
    }
}
