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
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        repo.refreshGoods(completion: { _ in
            self.table.reloadData()
        })
    }
}

// MARK: - NSTableViewDelegate
extension GoodsViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var cellView: NSTableCellView? = nil
        
        switch tableColumn?.identifier.rawValue {
        case "ID":
            cellView = makeCellView(id: "idCell") as? NSTableCellView
            cellView?.textField?.integerValue = repo.goods[row].id
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
