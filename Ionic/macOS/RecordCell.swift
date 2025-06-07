//
//  RecordCell.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/10/25.
//

import Cocoa

/// `RecordCell` is a custom table cell view that displays DNS record details.
/// It shows the name, type, content, TTL, status, and last change date of a record.
///
/// This cell is used in an `NSTableView` to provide a visual representation of
/// a `RecordResponse` in the UI.
class RecordCell: NSTableCellView {
    // MARK: - Outlets

    @IBOutlet weak var headerView: NSView!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var typeLabel: NSTextField!
    @IBOutlet weak var contentLabel: NSTextField!
    @IBOutlet weak var changeDateLabel: NSTextField!
    @IBOutlet weak var ttlLabel: NSTextField!

    // MARK: - Properties

    /// The record associated with the cell. When set, updates the cell UI.
    var record: RecordResponse? {
        didSet {
            updateCell()
        }
    }

    // MARK: - Lifecycle

    /// Called when the cell is drawn. Used to customize the appearance of the header view.
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        headerView.wantsLayer = true
        headerView.layer?.backgroundColor = NSColor.lightGray.cgColor
        headerView.layer?.opacity = 0.5
    }

    // MARK: - UI Updates

    /// Updates the UI labels based on the current record data.
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
