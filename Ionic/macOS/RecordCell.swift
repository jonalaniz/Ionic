//
//  RecordCell.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/10/25.
//

import Cocoa

class RecordCell: NSTableCellView {
    @IBOutlet weak var headerView: NSView!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var typeLabel: NSTextField!
    @IBOutlet weak var contentLabel: NSTextField!
    @IBOutlet weak var changeDateLabel: NSTextField!
    @IBOutlet weak var ttlLabel: NSTextField!

    var record: RecordResponse? {
        didSet {
            updateCell()
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        headerView.wantsLayer = true
        headerView.layer?.backgroundColor = NSColor.lightGray.cgColor
        headerView.layer?.opacity = 0.5
    }

    private func updateCell() {
        guard let record = record else { return }
        nameLabel.stringValue = record.name
        typeLabel.stringValue = "Type: \(record.type.rawValue)"
        contentLabel.stringValue = "Content: \(record.content)"
        changeDateLabel.stringValue = "Change Date: \(record.changeDate.readableDate())"
        ttlLabel.stringValue = "TTL: \(record.ttl)"
        statusLabel.stringValue = record.disabled ? "🔴" : "🟢"
    }
}
