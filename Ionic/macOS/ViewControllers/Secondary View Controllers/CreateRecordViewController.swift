//
//  CreateRecordViewController.swift
//  Ionic
//
//  Created by Jon Alaniz on 5/27/25.
//

import Cocoa

class CreateRecordViewController: NSViewController {
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var recordTypeButton: NSPopUpButton!
    @IBOutlet weak var contentLabel: NSTextField!
    @IBOutlet weak var contentTextField: NSTextField!
    @IBOutlet weak var ttlPopupButton: NSPopUpButton!
    @IBOutlet weak var priorityTextLabel: NSTextField!
    @IBOutlet weak var priorityTextField: NSTextField!
    @IBOutlet weak var recordTypeLabel: NSTextField!
    @IBOutlet weak var recordTypeDescriptionTextField: NSTextField!
    @IBOutlet weak var recordPreviewTextField: NSTextField!
    
    let recordFactory = RecordFactory.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenus()
        setupTextFields()
        updatePreview()
    }
    
    private func setupMenus() {
        setupRecordTypeMenu()
        setupTTLMenu()
    }
    
    private func setupTextFields() {
        nameTextField.delegate = self
        contentTextField.delegate = self
        priorityTextField.delegate = self
    }
    
    private func setupRecordTypeMenu() {
        guard let menu = recordTypeButton.menu else { return }
        menu.removeAllItems()
        
        for type in RecordType.allCases where !type.experimental() {
            let item = NSMenuItem(
                title: type.rawValue,
                action: #selector(didSelectRecordType),
                keyEquivalent: ""
            )
            
            item.representedObject = type
            item.target = self
            menu.addItem(item)
        }
    }
    
    private func setupTTLMenu() {
        guard let menu = ttlPopupButton.menu else { return }
        menu.removeAllItems()
        
        for ttl in TTL.allCases {
            let item = NSMenuItem(
                title: ttl.description,
                action: #selector(updatePreview),
                keyEquivalent: ""
            )
            
            item.representedObject = ttl
            item.target = self
            menu.addItem(item)
        }
        
        ttlPopupButton.selectItem(at: 3)
    }
    
    @objc private func didSelectRecordType(_ sender: NSMenuItem) {
        guard let type = sender.representedObject as? RecordType else { return }
        updateUI(for: type)
        updatePreview()
    }
    
    @objc private func updatePreview() {
        guard
            let domain = recordFactory.domain,
            let ttl = ttlPopupButton.selectedItem?.representedObject as? TTL,
            let recordType = recordTypeButton.selectedItem?.representedObject as? RecordType
        else {
            assertionFailure("Missing required DNS record components.")
            return
        }
        
        let host = nameTextField.stringValue == "@" ? "" : nameTextField.stringValue + "."
        let previewString = "\(host)\(domain) \(ttl.rawValue) IN \(recordType.rawValue) \(contentTextField.stringValue)"
        recordPreviewTextField.placeholderString = previewString
    }
    
    private func updateUI(for type: RecordType) {
        recordTypeLabel.stringValue = "\(type.name):"
        recordTypeDescriptionTextField.stringValue = type.description
        
        contentLabel.stringValue = type.contentLabel + ":"
        
        let priority = type.requiresPriority()
        priorityTextField.isEnabled = priority
        priorityTextLabel.textColor = priority ? .labelColor : .secondaryLabelColor
    }
}

extension CreateRecordViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        updatePreview()
    }
}
