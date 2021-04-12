//
//  ChooseGoodCellView.swift
//  Wholesale Company Manager
//
//  Created by panandafog on 12.04.2021.
//

import Cocoa

class ChooseGoodCellView: NSTableCellView {

    let repo = Repository.shared
    
    @IBOutlet var comboBox: NSComboBox!
    
    override func viewWillDraw() {
        super.viewWillDraw()
        comboBox.usesDataSource = true
        comboBox.delegate = self
        comboBox.dataSource = self

        comboBox.reloadData()
    }

    func selectGood(at index: Int) {
        guard index >= 0 && index < repo.goods.count else {
            return
        }
        
        viewWillDraw()
        comboBox.selectItem(at: index)
    }
}

// MARK: - NSComboBoxDelegate

extension ChooseGoodCellView: NSComboBoxDelegate {

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

extension ChooseGoodCellView: NSComboBoxDataSource {

    func numberOfItems(in comboBox: NSComboBox) -> Int {
        repo.goods.count
    }
}
