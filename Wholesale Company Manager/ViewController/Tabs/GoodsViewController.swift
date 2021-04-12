//
//  GoodsViewController.swift
//  Wholesale Company Manager
//
//  Created by panandafog on 10.04.2021.
//

import Cocoa

class GoodsViewController: NSViewController {
    
    private var repo = Repository.shared
    
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
    @IBAction func addButtonPressed(_ sender: Any) {
        repo.addGood(completion: {
            self.refreshTableData()
        })
    }
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        let selectedRows = table.selectedRowIndexes
        for selectedRow in selectedRows {
            if selectedRow >= 0 && selectedRow < repo.goods.count {
                let selectedGood = repo.goods[selectedRow]
                self.repo.deleteGood(selectedGood, completion: {
                    self.refreshTableData()
                })
            }
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        refreshTableData()
    }
    
    @IBAction func nameEdited(_ sender: NSTextField) {
        guard let row = sender.superview?.superview,
              let table = row.superview as? NSTableView else {
            return
        }

        var selectedGood = repo.goods[table.row(for: sender)]
        selectedGood.name = sender.stringValue
        repo.saveGood(selectedGood, completion: {
            self.refreshTableData()
        })
    }
    
    @IBAction func priorityEdited(_ sender: NSTextField) {
        guard let row = sender.superview?.superview,
              let table = row.superview as? NSTableView else {
            return
        }

        var selectedGood = repo.goods[table.row(for: sender)]
        selectedGood.priority = sender.integerValue
        repo.saveGood(selectedGood, completion: {
            self.refreshTableData()
        })
    }
    
    // MARK: refreshTableData
    private func refreshTableData() {
        repo.refreshGoods(completion: { goods in
            self.onTableDataChanged(goods)
        })
    }
    
    // MARK: onTableDataChanged
    private func onTableDataChanged() {
        onTableDataChanged(repo.goods)
    }
    
    private func onTableDataChanged(_ goods: [Good]) {
        self.table.reloadData()
        
        if goods.isEmpty {
            removeButton.isEnabled = false
        }
    }
}

// MARK: - NSTableViewDelegate
extension GoodsViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var cellView: NSTableCellView? = nil
        
        switch tableColumn?.identifier.rawValue {
        case "ID":
            cellView = makeCellView(id: "idCell") as? NSTableCellView
            if let id = repo.goods[row].id {
                cellView?.textField?.integerValue = id
            }
        case "Name":
            cellView = makeCellView(id: "nameCell") as? NSTableCellView
            cellView?.textField?.stringValue = repo.goods[row].name
        case "Priority":
            cellView = makeCellView(id: "priorityCell") as? NSTableCellView
            cellView?.textField?.integerValue = repo.goods[row].priority
        default:
            return nil
        }
        
        return cellView
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        removeButton.isEnabled = table.numberOfSelectedRows > 0
    }
    
    private func makeCellView(id: String) -> NSView? {
        table.makeView(
            withIdentifier: NSUserInterfaceItemIdentifier(rawValue: id),
            owner: self)
    }
}

// MARK: - NSTableViewDataSource
extension GoodsViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        repo.goods.count
    }
}
