//
//  InspectorViewController.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/13/25.
//

import Cocoa

class InspectorViewController: NSViewController {
    @IBOutlet weak var noSelectionLabel: NSTextField!
    @IBOutlet weak var inspectorView: NSView!
    @IBOutlet weak var idTextField: NSTextField!
    @IBOutlet weak var contentTextField: NSTextField!
    @IBOutlet weak var rootTextField: NSTextField!
    @IBOutlet weak var typeValueLabel: NSTextField!
    @IBOutlet weak var ttlValueLabel: NSTextField!
    @IBOutlet weak var priorityValueLabel: NSTextField!
    @IBOutlet weak var lastChangedValueLabel: NSTextField!
    
    var dnsRecord: DNSRecordResponse? {
        didSet {
            updateLabels()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateRecord), name: .selectedRecordDidChange, object: nil)
    }

    @objc func updateRecord(_ notification: Notification) {
        guard let record = notification.object as? DNSRecordResponse else {
            toggleInspector(itemIsSelected: false)
            return
        }
        dnsRecord = record
    }

    private func updateLabels() {
        guard let record = dnsRecord else { return }
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
