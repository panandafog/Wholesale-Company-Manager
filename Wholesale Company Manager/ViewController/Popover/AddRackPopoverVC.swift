//
//  AddRackPopoverVC.swift
//  Wholesale Company Manager
//
//  Created by panandafog on 13.04.2021.
//

import Cocoa

class AddRackPopoverVC: NSViewController {
    
    var completion: ((_ rack: Rack) -> Void)?
    
    private var repo = Repository.shared
    
    @IBOutlet var goodComboBox: NSComboBox!
    @IBOutlet var countTextField: NSTextField!
    @IBOutlet var submitButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goodComboBox.usesDataSource = true
        goodComboBox.delegate = self
        goodComboBox.dataSource = self

        goodComboBox.reloadData()
        goodComboBox.selectItem(at: 0)
    }
    
    // MARK: IBActions
    @IBAction func goodSelectionChanged(_ sender: NSComboBox) {
    }
    
    @IBAction func countValueChanged(_ sender: NSTextField) {
        submitButton.isEnabled = true
    }
    
    @IBAction func submit(_ sender: Any) {
        let good = repo.goods[goodComboBox.indexOfSelectedItem]
        let count = countTextField.integerValue

        let rack = Rack(
            id: nil,
            good: good,
            goodCount: count)
        
        if let completion = completion {
            completion(rack)
        }
    }
}

// MARK: - NSComboBoxDelegate
extension AddRackPopoverVC: NSComboBoxDelegate {
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
extension AddRackPopoverVC: NSComboBoxDataSource {

    func numberOfItems(in comboBox: NSComboBox) -> Int {
        repo.goods.count
    }
}

