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
    
    func refreshGoods(completion: @escaping ((_ goods: [Good]) -> Void)) {
        client.getAllGoods(completion: { goods in
            self.goods = goods
            completion(goods)
        })
    }
}
