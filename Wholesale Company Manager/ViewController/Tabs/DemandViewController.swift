//
//  DemandViewController.swift
//  Wholesale Company Manager
//
//  Created by panandafog on 14.04.2021.
//

import Cocoa

class DemandViewController: NSViewController {
    
    private var repo = Repository.shared
    private var demand = [DailyDemand]()
    
    @IBOutlet var popularGoodsTable: NSTableView!
    @IBOutlet var demandTable: NSTableView!
    @IBOutlet var refreshButton: NSButton!
    
    @IBOutlet var goodComboBox: NSComboBox!
    @IBOutlet var fromDatePicker: NSDatePicker!
    @IBOutlet var toDatePicker: NSDatePicker!
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popularGoodsTable.delegate = self
        popularGoodsTable.dataSource = self
        
        demandTable.delegate = self
        demandTable.dataSource = self
        
        goodComboBox.usesDataSource = true
        goodComboBox.delegate = self
        goodComboBox.dataSource = self

        goodComboBox.reloadData()
        goodComboBox.selectItem(at: 0)
        
        refreshPopularTable()
    }
    
    // MARK: IBActions
    @IBAction func refreshButtonPressed(_ sender: Any) {
        refreshTableData()
    }
    
    @IBAction func goodSelectionChanged(_ sender: Any) {
        refreshDemandTable()
    }
    
    // MARK: refreshTableData
    private func refreshTableData() {
        repo.refreshGoods(completion: { _ in
            self.refreshPopularTable()
            self.refreshDemandTable()
        })
    }
    
    private func refreshPopularTable() {
        repo.refreshMostPopularGoods(completion: { goods in
            self.onTableDataChanged(goods)
        })
    }
    
    private func refreshDemandTable() {
        
        guard goodComboBox.indexOfSelectedItem >= 0
                && goodComboBox.indexOfSelectedItem < repo.goods.count else {
            return
        }
        
        guard let goodID = repo.goods[goodComboBox.indexOfSelectedItem].id else {
            return
        }
        
        repo.getDemand(goodID: goodID, minTime: fromDatePicker.dateValue, maxTime: toDatePicker.dateValue, completion: { demand in
            self.demand = demand
            self.onTableDataChanged(demand)
        })
    }
    
    // MARK: onTableDataChanged
    private func onTableDataChanged(_ goods: [Good]) {
        self.popularGoodsTable.reloadData()
    }
    
    private func onTableDataChanged(_ demand: [DailyDemand]) {
        self.demandTable.reloadData()
    }
}

// MARK: - NSTableViewDelegate
extension DemandViewController: NSTableViewDelegate {
    func viewForPopularGoodsTable(columnId: String?, row: Int) -> NSView? {
        var cellView: NSTableCellView? = nil
        
        switch columnId {
        case "ID":
            cellView = makeCellView(table: popularGoodsTable, id: "idCell") as? NSTableCellView
            if let id = repo.mostPopularGoods[row].id {
                cellView?.textField?.integerValue = id
            }
        case "Name":
            cellView = makeCellView(table: popularGoodsTable, id: "nameCell") as? NSTableCellView
            cellView?.textField?.stringValue = repo.mostPopularGoods[row].name
        case "Count":
            if let count = repo.mostPopularGoods[row].count {
                cellView = makeCellView(table: popularGoodsTable, id: "countCell") as? NSTableCellView
                cellView?.textField?.integerValue = count
            }
        default:
            return nil
        }
        
        return cellView
    }

    func viewForDemandTable(columnId: String?, row: Int) -> NSView? {
        var cellView: NSTableCellView? = nil
        
        switch columnId {
        case "Day":
            cellView = makeCellView(table: demandTable, id: "dayCell") as? NSTableCellView
            cellView?.textField?.integerValue = demand[row].day
        case "Count":
            cellView = makeCellView(table: demandTable, id: "countCell") as? NSTableCellView
            cellView?.textField?.doubleValue = demand[row].goodCount
        default:
            return nil
        }
        
        return cellView
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableView.identifier?.rawValue ?? "" == "popularGoodsTable" {
            return viewForPopularGoodsTable(columnId: tableColumn?.identifier.rawValue, row: row)
        }

        if tableView.identifier?.rawValue ?? "" == "demandTable" {
            return viewForDemandTable(columnId: tableColumn?.identifier.rawValue, row: row)
        }

        return nil
    }
    
    private func makeCellView(table: NSTableView, id: String) -> NSView? {
        table.makeView(
            withIdentifier: NSUserInterfaceItemIdentifier(rawValue: id),
            owner: self)
    }
}

// MARK: - NSTableViewDataSource
extension DemandViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        switch tableView.identifier?.rawValue ?? "" {

        case "popularGoodsTable":
            return repo.mostPopularGoods.count

        case "demandTable":
            return self.demand.count

        default:
            return 0
        }
    }
}

// MARK: - NSComboBoxDelegate
extension DemandViewController: NSComboBoxDelegate {

    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        guard index >= 0 && index < repo.goods.count else {
            return nil
        }
        
        var tmpName = repo.goods[index].name
        
        if let id = repo.goods[index].id {
            tmpName += " [" + String(id) + "]"
        }
        return tmpName
    }
}

// MARK: - NSComboBoxDataSource
extension DemandViewController: NSComboBoxDataSource {

    func numberOfItems(in comboBox: NSComboBox) -> Int {
        repo.goods.count
    }
}
