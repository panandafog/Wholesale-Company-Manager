//
//  StartViewController.swift
//  Wholesale Company Manager
//
//  Created by panandafog on 10.04.2021.
//

import Cocoa

class StartViewController: NSViewController {

    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: representedObject
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    // MARK: - logIn
    @IBAction func logIn(_ sender: Any) {
        guard let mainWindowController = NSStoryboard(name: "Main", bundle: nil).instantiateInitialController() as? MainWindowController else {
            return
        }
        self.view.window?.windowController?.close()
        mainWindowController.showWindow(self)
    }
}
