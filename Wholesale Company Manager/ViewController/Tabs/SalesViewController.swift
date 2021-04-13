//
//  SalesViewController.swift
//  Wholesale Company Manager
//
//  Created by panandafog on 10.04.2021.
//

import Cocoa

class SalesViewController: NSViewController {
    
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
        let popoverContentController = NSStoryboard(name: NSStoryboard.Name("Sales"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("AddSalePopoverVC")) as! AddSalePopoverVC
        popoverContentController.completion = { sale in
            self.presentedPopover?.close()
            self.repo.saveSale(sale, completion: self.refreshTableData)
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
            if selectedRow >= 0 && selectedRow < repo.sales.count {
                let selectedSale = repo.sales[selectedRow]
                self.repo.deleteSale(selectedSale, completion: {
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
        var selectedSale = repo.sales[table.row(for: sender)]
        selectedSale.good = newGood
        
        repo.saveSale(selectedSale, completion: {
            self.refreshTableData()
        })
    }
    
    @IBAction func countEdited(_ sender: NSTextField) {

        var selectedSale = repo.sales[table.row(for: sender)]
        selectedSale.goodCount = sender.integerValue
        repo.saveSale(selectedSale, completion: {
            self.refreshTableData()
        })
    }
    
    @IBAction func dateEdited(_ sender: NSTextField) {

        var selectedSale = repo.sales[table.row(for: sender)]
        selectedSale.createDate = sender.stringValue
        repo.saveSale(selectedSale, completion: {
            self.refreshTableData()
        })
    }
    
    // MARK: refreshTableData
    private func refreshTableData() {
        repo.refreshGoods(completion: { _ in
        })
        repo.refreshSales(completion: { sales in
            self.onTableDataChanged(sales)
        })
    }
    
    // MARK: onTableDataChanged
    private func onTableDataChanged() {
        onTableDataChanged(repo.sales)
    }
    
    private func onTableDataChanged(_ sales: [Sale]) {
        self.table.reloadData()
        
        if sales.isEmpty {
            removeButton.isEnabled = false
        }
    }
}

// MARK: - NSTableViewDelegate
extension SalesViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var cellView: NSTableCellView? = nil
        
        switch tableColumn?.identifier.rawValue {
        case "ID":
            cellView = makeCellView(id: "idCell") as? NSTableCellView
            if let id = repo.sales[row].id {
                cellView?.textField?.integerValue = id
            }
        case "Good":
            let tmpCellView = makeCellView(id: "goodCell") as? ChooseGoodCellView
            
            if let index = repo.goods.firstIndex(where: { good in
                good.id == repo.sales[row].good.id
            }) {
                tmpCellView?.selectGood(at: index)
            }
            cellView = tmpCellView
        case "Count":
            cellView = makeCellView(id: "countCell") as? NSTableCellView
            cellView?.textField?.integerValue = repo.sales[row].goodCount
        case "Date":
            cellView = makeCellView(id: "dateCell") as? NSTableCellView
            cellView?.textField?.stringValue = repo.sales[row].createDate
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
extension SalesViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        repo.sales.count
    }
}
