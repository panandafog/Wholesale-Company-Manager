//
//  SidebarViewController.swift
//  Wholesale Company Manager
//
//  Created by panandafog on 10.04.2021.
//

import Cocoa

class SidebarViewController: NSViewController {
    
    var tabButtons = [NSButton]()
    
    var switchTab: ((UInt) -> Void)?
    
    @IBOutlet var salesTabButton: NSButton!
    @IBOutlet var goodsTabButton: NSButton!
    @IBOutlet var smallWarehouseTabButton: NSButton!
    @IBOutlet var bigWarehouseTabButton: NSButton!
    @IBOutlet var demandTabButton: NSButton!
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabButtons = [
            salesTabButton,
            goodsTabButton,
            smallWarehouseTabButton,
            bigWarehouseTabButton,
            demandTabButton
        ]
        
        disableTabSelectors(excluding: salesTabButton)
    }
    
    // MARK: - switchTab
    @IBAction private func switchTab(_ sender: NSButton) {
        disableTabSelectors(excluding: sender)
        
        guard let switchTab = self.switchTab,
              let senderInd = tabButtons.firstIndex(of: sender) else {
            return
        }
        
        switchTab(UInt(senderInd))
    }
    
    // MARK: - disableTabSelectors
    func disableTabSelectors(excluding sender: NSButton) {
        tabButtons.forEach({
            if $0 != sender {
                $0.state = .off
            } else {
                $0.state = .on
            }
        })
    }
}
