//
//  Repository.swift
//  Wholesale Company Manager
//
//  Created by panandafog on 10.04.2021.
//

class Repository {
    
    private var client = APIClient()
    
    private (set) var goods = [Good]()
    private (set) var sales = [Sale]()
    private (set) var smallWarehouse = [Rack]()
    private (set) var bigWarehouse = [Rack]()
    
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
    
    // MARK: - refreshSales
    func refreshSales(completion: @escaping ((_ sales: [Sale]) -> Void)) {
        client.getAllSales(completion: { sales in
            self.sales = sales
            completion(sales)
        })
    }
    
    // MARK: addSale
//    func addSale(completion: (() -> Void)?) {
//        saveSale(Sale(), completion: completion)
//    }
    
    // MARK: saveSale
    func saveSale(_ sale: Sale, completion: (() -> Void)?) {
        client.saveSale(sale, completion: completion)
    }
    
    // MARK: deleteSale
    func deleteSale(_ sale: Sale, completion: (() -> Void)?) {
        guard let id = sale.id else {
            return
        }
        client.deleteSale(id: id, completion: completion)
    }
    
    // MARK: - refreshWarehouse
    func refreshWarehouse(warehouse: Warehouse, completion: @escaping ((_ racks: [Rack]) -> Void)) {
        client.getAllRacks(warehouse: warehouse, completion: {
            racks in
            switch warehouse {
            case .small:
                self.smallWarehouse = racks
            case .big:
                self.bigWarehouse = racks
            }
            completion(racks)
        })
    }
    
    // MARK: addRack
//    func addSale(completion: (() -> Void)?) {
//        saveSale(Sale(), completion: completion)
//    }
    
    // MARK: saveRack
    func saveRack(_ rack: Rack, warehouse: Warehouse,  completion: (() -> Void)?) {
        client.saveRack(rack, warehouse: warehouse, completion: completion)
    }
    
    // MARK: deleteRack
    func deleteRack(_ rack: Rack, warehouse: Warehouse,  completion: (() -> Void)?) {
        guard let id = rack.id else {
            return
        }
        client.deleteRack(id: id, warehouse: warehouse, completion: completion)
    }
}
