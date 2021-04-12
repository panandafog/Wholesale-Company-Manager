//
//  Repository.swift
//  Wholesale Company Manager
//
//  Created by panandafog on 10.04.2021.
//

class Repository {
    
    private var client = APIClient()
    
    private (set) var goods = [Good]()
    
    static var shared: Repository = {
        let instance = Repository()
        return instance
    }()
    
    private init() { }
    
    // MARK: - refreshGoods
    func refreshGoods(completion: @escaping ((_ goods: [Good]) -> Void)) {
        client.getAllGoods(completion: { goods in
            self.goods = goods
            completion(goods)
        })
    }
    
    // MARK: addGood
    func addGood(completion: (() -> Void)?) {
        saveGood(Good(), completion: completion)
    }
    
    // MARK: saveGood
    func saveGood(_ good: Good, completion: (() -> Void)?) {
        client.saveGood(good, completion: completion)
    }
    
    // MARK: deleteGood
    func deleteGood(_ good: Good, completion: (() -> Void)?) {
        guard let id = good.id else {
            return
        }
        client.deleteGood(id: id, completion: completion)
    }
}
