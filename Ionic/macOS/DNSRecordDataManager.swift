//
//  NSRecordDataManager.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/10/25.
//

import Cocoa

protocol DNSRecordDataManagerDelegate: NSObject {
    func recordWasUpdated(_ recordName: String)
}

class DNSRecordDataManager: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    static let shared = DNSRecordDataManager()
    weak var delegate: DNSRecordDataManagerDelegate?

    var zoneDetails: ZoneDetails? {
        didSet {
            notifyDelegate()
        }
    }

    private override init() {}

    func numberOfRows(in tableView: NSTableView) -> Int {
        return zoneDetails?.records.count ?? 0
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let record = zoneDetails?.records[row] else { return nil }
        let identifier = NSUserInterfaceItemIdentifier("RecordCell")
        guard let cell = tableView.makeView(withIdentifier: identifier, owner: self) as? RecordCell else { return nil }

        cell.record = record
        return cell
    }

    private func notifyDelegate() {
        guard let name = zoneDetails?.name else { return }
        delegate?.recordWasUpdated(name)
    }
}
