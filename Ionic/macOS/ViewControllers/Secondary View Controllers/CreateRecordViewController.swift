//
//  CreateRecordViewController.swift
//  Ionic
//
//  Created by Jon Alaniz on 5/27/25.
//

import Cocoa

class CreateRecordViewController: NSViewController {
    @IBOutlet weak var recordTypeButton: NSPopUpButton!
    
    override func viewDidLoad() {
        createTypeMenuItems()
    }
    
    private func createTypeMenuItems() {
        guard let menu = recordTypeButton.menu else { return }
        
        for type in RecordType.allCases {
            guard !type.experimental() else { continue }
            let item = NSMenuItem(
                title: type.rawValue,
                action: #selector(updateRequirementsForSelectedType),
                keyEquivalent: ""
            )
            
            item.representedObject = type
            item.target = self
            menu.addItem(item)
        }
    }
    
    @objc private func updateRequirementsForSelectedType(_ sender: NSMenuItem) {
        
    }
}
