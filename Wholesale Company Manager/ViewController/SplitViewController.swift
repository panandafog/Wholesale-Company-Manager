//
//  SplitViewController.swift
//  Wholesale Company Manager
//
//  Created by panandafog on 10.04.2021.
//

import Cocoa

class SplitViewController: NSSplitViewController {
    
    let salesViewController = NSStoryboard(name: "Sales", bundle: nil).instantiateController(withIdentifier: "SalesViewController")
        as! SalesViewController
    let goodsViewController = NSStoryboard(name: "Goods", bundle: nil).instantiateController(withIdentifier: "GoodsViewController")
        as! GoodsViewController
    let smallWarehouseViewController = NSStoryboard(name: "SmallWarehouse", bundle: nil).instantiateController(withIdentifier: "SmallWarehouseViewController")
        as! SmallWarehouseViewController
    let bigWarehouseViewController = NSStoryboard(name: "BigWarehouse", bundle: nil).instantiateController(withIdentifier: "BigWarehouseViewController")
        as! BigWarehouseViewController
    let demandViewController = NSStoryboard(name: "Demand", bundle: nil).instantiateController(withIdentifier: "DemandViewController")
        as! DemandViewController
    
    var sidebarViewController: SidebarViewController?
    
    var tabControllers = [NSViewController]()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabControllers = [
            salesViewController,
            goodsViewController,
            smallWarehouseViewController,
            bigWarehouseViewController,
            demandViewController
        ]
        
        sidebarViewController = self.children[0] as? SidebarViewController
        sidebarViewController?.switchTab = self.switchTab(_:)
        
        self.addChild(self.salesViewController)
    }
    
    // MARK: - switchTab
    func switchTab(_ number: UInt) {
        if number < tabControllers.count {
            removeChild(at: self.children.count - 1)
            addChild(tabControllers[Int(number)])
        }
    }
}
