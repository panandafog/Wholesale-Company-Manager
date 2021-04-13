//
//  BigWarehouseViewController.swift
//  Wholesale Company Manager
//
//  Created by panandafog on 10.04.2021.
//

import Cocoa

class BigWarehouseViewController: NSViewController {
    
    private var repo = Repository.shared
    
    var presentedPopover: NSPopover?
    
    @IBOutlet var table: NSTableView!
    @IBOutlet var addButton: NSButton!
    @IBOutlet var removeButton: NSButton!
    @IBOutlet var refreshButton: NSButton!
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        refreshTableData()
    }
    
    // MARK: IBActions
    @IBAction func addButtonPressed(_ sender: NSButton) {
        let popoverContentController = NSStoryboard(name: NSStoryboard.Name("AddRackPopover"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("AddRackPopoverVC")) as! AddRackPopoverVC
        popoverContentController.completion = { rack in
            self.presentedPopover?.close()
            self.repo.saveRack(rack, warehouse: .big, completion: self.refreshTableData)
        }
        
        presentedPopover = NSPopover()
        presentedPopover?.behavior = .semitransient
        presentedPopover?.animates = true
        presentedPopover?.contentViewController = popoverContentController
        presentedPopover?.show(relativeTo: sender.bounds, of: sender, preferredEdge: .maxX)
    }
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        let selectedRows = table.selectedRowIndexes
        for selectedRow in selectedRows {
            if selectedRow >= 0 && selectedRow < repo.bigWarehouse.count {
                let selectedRack = repo.bigWarehouse[selectedRow]
                self.repo.deleteRack(selectedRack, warehouse: .big, completion: {
                    self.refreshTableData()
                })
            }
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        refreshTableData()
    }
    
    @IBAction func goodEdited(_ sender: NSComboBox) {
        
        let row = table.row(for: sender)
        guard sender.indexOfSelectedItem >= 0
                && sender.indexOfSelectedItem < repo.goods.count
                && row >= 0 && row < repo.sales.count else {
            return
        }
        
        let newGood = repo.goods[sender.indexOfSelectedItem]
        var selectedRack = repo.bigWarehouse[table.row(for: sender)]
        selectedRack.good = newGood
        
        repo.saveRack(selectedRack, warehouse: .big, completion: {
            self.refreshTableData()
        })
    }
    
    @IBAction func countEdited(_ sender: NSTextField) {

        var selectedRack = repo.bigWarehouse[table.row(for: sender)]
        selectedRack.goodCount = sender.integerValue
        repo.saveRack(selectedRack, warehouse: .big, completion: {
            self.refreshTableData()
        })
    }
        
    // MARK: refreshTableData
    private func refreshTableData() {
        repo.refreshGoods(completion: { _ in
        })
        repo.refreshWarehouse(warehouse: .big, completion: { racks in
            self.onTableDataChanged(racks)
        })
    }
    
    // MARK: onTableDataChanged
    private func onTableDataChanged() {
        onTableDataChanged(repo.bigWarehouse)
    }
    
    private func onTableDataChanged(_ racks: [Rack]) {
        self.table.reloadData()
        
        if racks.isEmpty {
            removeButton.isEnabled = false
        }
    }
}

// MARK: - NSTableViewDelegate
extension BigWarehouseViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var cellView: NSTableCellView? = nil
        
        switch tableColumn?.identifier.rawValue {
        case "ID":
            cellView = makeCellView(id: "idCell") as? NSTableCellView
            if let id = repo.bigWarehouse[row].id {
                cellView?.textField?.integerValue = id
            }
        case "Good":
            let tmpCellView = makeCellView(id: "goodCell") as? ChooseGoodCellView
            
            if let index = repo.goods.firstIndex(where: { good in
                good.id == repo.bigWarehouse[row].good.id
            }) {
                tmpCellView?.selectGood(at: index)
            }
            cellView = tmpCellView
        case "Count":
            cellView = makeCellView(id: "countCell") as? NSTableCellView
            cellView?.textField?.integerValue = repo.bigWarehouse[row].goodCount
        default:
            return nil
        }
        
        return cellView
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        removeButton.isEnabled = table.numberOfSelectedRows > 0
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        20
    }
    
    private func makeCellView(id: String) -> NSView? {
        table.makeView(
            withIdentifier: NSUserInterfaceItemIdentifier(rawValue: id),
            owner: self)
    }
}

// MARK: - NSTableViewDataSource
extension BigWarehouseViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        repo.bigWarehouse.count
    }
}
