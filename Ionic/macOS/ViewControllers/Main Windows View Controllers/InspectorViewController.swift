//
//  InspectorViewController.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/13/25.
//

import Cocoa

class InspectorViewController: MainWindowViewController {
    @IBOutlet weak var noSelectionLabel: NSTextField!
    @IBOutlet weak var inspectorView: NSView!
    @IBOutlet weak var idTextField: NSTextField!
    @IBOutlet weak var contentTextField: NSTextField!
    @IBOutlet weak var rootTextField: NSTextField!
    @IBOutlet weak var typeValueLabel: NSTextField!
    @IBOutlet weak var ttlValueLabel: NSTextField!
    @IBOutlet weak var ttlPopupButton: NSPopUpButton!
    @IBOutlet weak var priorityValueLabel: NSTextField!
    @IBOutlet weak var lastChangedValueLabel: NSTextField!
    @IBOutlet weak var disableButton: NSButton!
    @IBOutlet weak var buttonView: NSView!
    @IBOutlet weak var editingView: NSView!

    var editingMode = false {
        didSet { toggleEditingMode() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTTLMenu()
    }

    override func recordSelected() {
        let selected = recordManager.selectedRecord != nil
        toggleInspector(itemIsSelected: selected)
        updateLabels()
    }

    override func recordUpdated() {
        let selected = recordManager.selectedRecord != nil
        toggleInspector(itemIsSelected: selected)
        updateLabels()
    }

    override func zoneUpdated() {
        toggleInspector(itemIsSelected: false)
    }

    private func setupTTLMenu() {
        guard let menu = ttlPopupButton.menu else { return }
        menu.removeAllItems()

        for ttl in TTL.allCases {
            let item = NSMenuItem(
                title: ttl.description,
                action: nil,
                keyEquivalent: ""
            )

            item.representedObject = ttl
            item.target = self
            item.tag = ttl.rawValue
            menu.addItem(item)
        }
    }

    @IBAction func toggleEditing(_ sender: NSButton) {
        editingMode.toggle()
    }

    @IBAction func toggleEnabledStatus(_ sender: NSButton) {
        guard let record = recordManager.selectedRecord else { return }
        let buttonTitle = record.disabled ? "Enable" : "Disable"
        let action = record.disabled ? "enable" : "disable"

        let alert = alert(style: .warning,
                          buttonTitle: buttonTitle,
                          message: "Are you sure you want to \(action) this record?")

        show(alert) { self.toggleDisabledStatus() }
    }

    @IBAction func deleteRecord(_ sender: NSButton) {
        let alert = alert(style: .critical,
                          buttonTitle: "Delete",
                          message: "Are you sure you want to delete this record?",
                          informativeText: "This action cannot be undone.")

        show(alert) { self.deleteRecord() }
    }

    private func alert(
        style: NSAlert.Style,
        buttonTitle: String,
        message: String,
        informativeText: String? = nil
    ) -> NSAlert {
        let alert = NSAlert()
        let color: NSColor = style == .critical ? .red : .systemBlue

        alert.messageText = message
        alert.alertStyle = style
        if let text = informativeText { alert.informativeText = text }
        alert.addButton(withTitle: "Cancel")
        alert.addButton(withTitle: buttonTitle).bezelColor = color

        return alert
    }

    private func show(_ alert: NSAlert, completion: @escaping () -> Void) {
        guard let window = self.view.window else { return }
        alert.beginSheetModal(for: window) { response in
            if response == .alertSecondButtonReturn { completion() }
        }
    }

    private func toggleDisabledStatus() {
        recordManager.toggleDisabledStatus()
    }

    private func deleteRecord() {
        print("record deleted")
    }

    private func updateLabels() {
        guard let record = recordManager.selectedRecord else { return }
        idTextField.placeholderString = record.id
        contentTextField.placeholderString = record.content
        rootTextField.placeholderString = record.rootName
        typeValueLabel.stringValue = record.type.rawValue
        ttlValueLabel.stringValue = String(record.ttl)

        if let prio = record.prio {
            priorityValueLabel.stringValue = String(prio)
        } else {
            priorityValueLabel.stringValue = "none"
        }

        lastChangedValueLabel.stringValue = record.changeDate.readableDate()

        record.disabled ? (disableButton.title = "Enable") : (disableButton.title = "Disable")

        ttlPopupButton.selectItem(withTag: record.ttl)

        toggleInspector(itemIsSelected: true)
    }

    private func toggleEditingMode() {
        ttlValueLabel.isHidden = editingMode
        buttonView.isHidden = editingMode
        ttlPopupButton.isHidden = !editingMode
        editingView.isHidden = !editingMode

        contentTextField.isEditable = editingMode

        if editingMode {
            contentTextField.stringValue = contentTextField.placeholderString ?? ""
            view.window?.makeFirstResponder(contentTextField)
            ttlPopupButton.selectItem(withTag: recordManager.selectedRecord!.ttl)
        } else {
            contentTextField.stringValue = ""
        }
    }

    private func toggleInspector(itemIsSelected: Bool) {
        noSelectionLabel.isHidden = itemIsSelected
        inspectorView.isHidden = !itemIsSelected
    }
}
