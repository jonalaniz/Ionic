//
//  CreateRecordViewController.swift
//  Ionic
//
//  Created by Jon Alaniz on 5/27/25.
//

import Cocoa

// TODO: Clean this class up and reorganize
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
    @IBOutlet weak var createRecordButton: NSButton!

    let recordManager = DNSRecordDataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToNotificaton()
        setupMenus()
        setupTextFields()
        updatePreview()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
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
                action: #selector(didSelectTTL),
                keyEquivalent: ""
            )

            item.representedObject = ttl
            item.target = self
            menu.addItem(item)
        }

        ttlPopupButton.selectItem(at: 3)
    }

    @IBAction func createRecord(_ sender: NSButton) {
        guard
            let ttl = ttlPopupButton.selectedItem?.representedObject as? TTL,
            let type = recordTypeButton.selectedItem?.representedObject as? RecordType
        else { return }
        recordManager.createRecord(
            name: nameTextField.stringValue,
            type: type,
            content: contentTextField.stringValue,
            ttl: ttl,
            prio: nil
        )
    }

    @objc private func didSelectRecordType(_ sender: NSMenuItem) {
        guard let type = sender.representedObject as? RecordType else { return }
        updateUI(for: type)
        updatePreview()
        checkForValidRecord()
    }

    @objc private func didSelectTTL(_ sender: NSMenuItem) {
        updatePreview()
        checkForValidRecord()
    }

    @objc private func updatePreview() {
        guard
            let domain = recordManager.selectedZone?.name,
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

    private func checkForValidRecord() {
        guard
            nameTextField.stringValue != "",
            contentTextField.stringValue != ""
        else {
            createRecordButton.isEnabled = false
            return
        }
        createRecordButton.isEnabled = true
    }

    private func subscribeToNotificaton() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dismissController),
            name: .recordCreated,
            object: nil)
    }

    @objc private func dismissController() {
        self.dismiss(self)
    }
}

extension CreateRecordViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        updatePreview()
        checkForValidRecord()
    }
}
