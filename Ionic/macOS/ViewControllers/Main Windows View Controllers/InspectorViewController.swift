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
    @IBOutlet weak var priorityValueLabel: NSTextField!
    @IBOutlet weak var lastChangedValueLabel: NSTextField!
    @IBOutlet weak var disableButton: NSButton!

    override func recordUpdated() {
        let selected = recordManager.selectedRecord != nil
        toggleInspector(itemIsSelected: selected)
        updateLabels()
    }

    override func zoneUpdated() {
        toggleInspector(itemIsSelected: false)
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

    private func alert(style: NSAlert.Style, buttonTitle: String, message: String, informativeText: String? = nil) -> NSAlert {
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
        idTextField.stringValue = record.id
        contentTextField.stringValue = record.content
        rootTextField.stringValue = record.rootName
        typeValueLabel.stringValue = record.type.rawValue
        ttlValueLabel.stringValue = String(record.ttl)

        if let prio = record.prio {
            priorityValueLabel.stringValue = String(prio)
        } else {
            priorityValueLabel.stringValue = "none"
        }

        lastChangedValueLabel.stringValue = record.changeDate.readableDate()

        record.disabled ? (disableButton.title = "Enable") : (disableButton.title = "Disable")

        toggleInspector(itemIsSelected: true)
    }

    private func toggleInspector(itemIsSelected: Bool) {
        noSelectionLabel.isHidden = itemIsSelected
        inspectorView.isHidden = !itemIsSelected

        idTextField.isHidden = !itemIsSelected
        contentTextField.isHidden = !itemIsSelected
        rootTextField.isHidden = !itemIsSelected
        typeValueLabel.isHidden = !itemIsSelected
        ttlValueLabel.isHidden = !itemIsSelected
        priorityValueLabel.isHidden = !itemIsSelected
        lastChangedValueLabel.isHidden = !itemIsSelected
    }
}
