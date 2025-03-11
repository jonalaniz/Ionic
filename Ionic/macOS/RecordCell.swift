//
//  RecordCell.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/10/25.
//

import Cocoa

/*
 "records": [
   {
     "id": "22af3414-abbe-9e11-5df5-66fbe8e334b4",
     "name": "example-zone.de",
     "rootName": "example-zone.de",
     "type": "A",
     "content": "1.1.1.1",
     "changeDate": "2019-12-09T13:04:25.772Z",
     "ttl": 3600,
     "prio": 0,
     "disabled": false
   }
 */

class RecordCell: NSTableCellView {
    @IBOutlet weak var headerView: NSView!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var idLabel: NSTextField!
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var typeLabel: NSTextField!
    @IBOutlet weak var contentLabel: NSTextField!
    @IBOutlet weak var changeDateLabel: NSTextField!
    @IBOutlet weak var ttlLabel: NSTextField!
    
    var record: DNSRecord? {
        didSet {
            updateCell()
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        headerView.wantsLayer = true
        headerView.layer?.backgroundColor = NSColor.darkGray.cgColor
        headerView.layer?.opacity = 0.5
        // Drawing code here.
    }

    private func updateCell() {
        guard let record = record else { return }
        idLabel.stringValue = "ID: \(record.id)"
        nameLabel.stringValue = record.name
        typeLabel.stringValue = "Type: \(record.type)"
        contentLabel.stringValue = "Content: \(record.content)"
        changeDateLabel.stringValue = "Change Date: \(record.changeDate)"
        ttlLabel.stringValue = "TTL: \(record.ttl)"
        statusLabel.stringValue = record.disabled ? "🔴" : "🟢"
    }

}
