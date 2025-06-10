//
//  InspectorViewController.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/13/25.
//

import Cocoa

class InspectorViewController: MainWindowViewController {
    // MARK: - Outlets

    @IBOutlet weak var noSelectionLabel: NSTextField!
    @IBOutlet weak var inspectorView: NSView!
    @IBOutlet weak var idTextField: NSTextField!
    @IBOutlet weak var contentTextField: NSTextField!
    @IBOutlet weak var rootTextField: NSTextField!
    @IBOutlet weak var typeValueLabel: NSTextField!
    @IBOutlet weak var ttlValueLabel: NSTextField!
    @IBOutlet weak var ttlPopupButton: NSPopUpButton!
    @IBOutlet weak var priorityValueLabel: NSTextField!
    @IBOutlet weak var priorityTextField: NSTextField!
    @IBOutlet weak var lastChangedValueLabel: NSTextField!
    @IBOutlet weak var disableButton: NSButton!
    @IBOutlet weak var buttonView: NSView!
    @IBOutlet weak var editingView: NSView!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!

    // MARK: - Propertiees

    var editingMode = false {
        didSet { toggleEditingMode() }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTTLMenu()
    }

    // MARK: - Configuration

    private func setupTTLMenu() {
        guard let menu = ttlPopupButton.menu else { return }
        menu.removeAllItems()

        for ttl in TTL.allCases {
            let item = NSMenuItem(
                title: "\(ttl.rawValue) (\(ttl.description))",
                action: nil,
                keyEquivalent: ""
            )

            item.representedObject = ttl
            item.target = self
            item.tag = ttl.rawValue
            menu.addItem(item)
        }
    }

    // MARK: - Notification Handlers

    override func recordDeleted() {
        progressIndicator.stopAnimation(self)
        toggleInspector(itemIsSelected: false)
    }

    override func recordSelected() {
        let selected = recordManager.selectedRecord != nil
        toggleInspector(itemIsSelected: selected)
        updateLabels()
    }

    override func recordUpdated() {
        progressIndicator.stopAnimation(self)
        let selected = recordManager.selectedRecord != nil
        toggleInspector(itemIsSelected: selected)
        updateLabels()

        editingMode = false
    }

    override func zonesReloaded() {
        toggleInspector(itemIsSelected: false)
    }

    override func zoneUpdated() {
        toggleInspector(itemIsSelected: false)
    }

    // MARK: - Actions

    @IBAction func deleteRecordPressed(_ sender: NSButton) {
        let alert = alert(style: .critical,
                          buttonTitle: "Delete",
                          message: "Are you sure you want to delete this record?",
                          informativeText: "This action cannot be undone.")

        show(alert) { self.deleteRecord() }
    }

    @IBAction func updateButtonPressed(_ sender: NSButton) {
        let alert = alert(style: .warning,
        buttonTitle: "Update",
        message: "Are you sure you want to update this record?")

        show(alert) { self.updateRecord() }
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

    // MARK: - Alerts

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

    // MARK: - UI Updates

    private func toggleEditingMode() {
        guard let record = recordManager.selectedRecord else {
            assertionFailure("Inspector should not be editable when no record is selected")
            return
        }

        ttlValueLabel.isHidden = editingMode
        ttlPopupButton.isHidden = !editingMode
        buttonView.isHidden = editingMode
        editingView.isHidden = !editingMode
        contentTextField.isEditable = editingMode

        if editingMode {
            contentTextField.stringValue = contentTextField.placeholderString ?? ""
            priorityTextField.stringValue = priorityValueLabel.stringValue
            ttlPopupButton.selectItem(withTag: recordManager.selectedRecord!.ttl)
            view.window?.makeFirstResponder(contentTextField)
        } else {
            contentTextField.stringValue = ""
            priorityTextField.stringValue = ""
        }

        if record.type.requiresPriority() {
            priorityValueLabel.isHidden = editingMode
            priorityTextField.isHidden = !editingMode
        }
    }

    private func toggleInspector(itemIsSelected: Bool) {
        noSelectionLabel.isHidden = itemIsSelected
        inspectorView.isHidden = !itemIsSelected
    }

    private func updateLabels() {
        guard
            let record = recordManager.selectedRecord,
            let ttl = TTL(rawValue: record.ttl)
        else { return }
        idTextField.placeholderString = record.id
        contentTextField.placeholderString = record.content
        rootTextField.placeholderString = record.rootName
        typeValueLabel.stringValue = record.type.rawValue
        ttlValueLabel.stringValue = "\(ttl.rawValue) (\(ttl.description))"

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

    // MARK: - Helper Methods

    private func deleteRecord() {
        recordManager.deleteRecord()
        progressIndicator.startAnimation(self)
    }

    private func toggleDisabledStatus() {
        recordManager.toggleDisabledStatus()
        progressIndicator.startAnimation(self)
    }

    private func updateRecord() {
        guard
            let disabled = recordManager.selectedRecord?.disabled,
            let ttl = ttlPopupButton.selectedItem?.tag
        else { return }
        recordManager.updateRecord(
            content: contentTextField.stringValue,
            disabled: disabled,
            ttl: ttl,
            prio: Int(priorityTextField.stringValue))
        progressIndicator.startAnimation(self)
    }
}
