//
//  InspectorViewController.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/13/25.
//

import Cocoa

class InspectorViewController: NSViewController {
    @IBOutlet weak var noSelectionLabel: NSTextField!
    @IBOutlet weak var detailsLabel: NSTextField!
    @IBOutlet weak var idLabel: NSTextField!
    @IBOutlet weak var idValueLabel: NSTextField!
    @IBOutlet weak var rootLabel: NSTextField!
    @IBOutlet weak var rootValueLabel: NSTextField!
    @IBOutlet weak var contentLabel: NSTextField!
    @IBOutlet weak var contentValueLabel: NSTextField!
    @IBOutlet weak var typeLabel: NSTextField!
    @IBOutlet weak var typeValueLabel: NSTextField!
    @IBOutlet weak var ttlLabel: NSTextField!
    @IBOutlet weak var ttlValueLabel: NSTextField!
    @IBOutlet weak var priorityLabel: NSTextField!
    @IBOutlet weak var priorityValueLabel: NSTextField!
    @IBOutlet weak var horizontalLine: NSBox!
    @IBOutlet weak var disableButton: NSButton!
    @IBOutlet weak var editButton: NSButton!
    @IBOutlet weak var deleteButton: NSButton!

    var dnsRecord: DNSRecordResponse? {
        didSet {
            updateLabels()
            toggleInspector(itemIsSelected: true)
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
        idValueLabel.stringValue = record.id
        rootValueLabel.stringValue = record.rootName
        contentValueLabel.stringValue = record.content
        typeValueLabel.stringValue = record.type.rawValue
        ttlValueLabel.stringValue = String(record.ttl)

        guard let prio = record.prio else {
            priorityValueLabel.stringValue = "none"
            return
        }
        priorityValueLabel.stringValue = String(prio)
    }

    private func toggleInspector(itemIsSelected: Bool) {
        noSelectionLabel.isHidden = itemIsSelected

        detailsLabel.isHidden = !itemIsSelected
        idLabel.isHidden = !itemIsSelected
        rootLabel.isHidden = !itemIsSelected
        contentLabel.isHidden = !itemIsSelected
        typeLabel.isHidden = !itemIsSelected
        ttlLabel.isHidden = !itemIsSelected
        priorityLabel.isHidden = !itemIsSelected

        idValueLabel.isHidden = !itemIsSelected
        rootValueLabel.isHidden = !itemIsSelected
        contentValueLabel.isHidden = !itemIsSelected
        typeValueLabel.isHidden = !itemIsSelected
        ttlValueLabel.isHidden = !itemIsSelected
        priorityValueLabel.isHidden = !itemIsSelected
        
        horizontalLine.isHidden = !itemIsSelected
        
        disableButton.isHidden = !itemIsSelected
        editButton.isHidden = !itemIsSelected
        deleteButton.isHidden = !itemIsSelected
    }
}
