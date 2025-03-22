//
//  NSRecordDataManager.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/10/25.
//

import Cocoa

protocol DNSRecordDataManagerDelegate: NSObject {
    func recordWasUpdated(_ zoneName: String)
}

class DNSRecordDataManager: NSObject {
    static let shared = DNSRecordDataManager()
    weak var delegate: DNSRecordDataManagerDelegate?

    var selectedRecord: DNSRecordResponse? {
        didSet {
            NotificationCenter.default.post(name: .selectedRecordDidChange, object: selectedRecord)
        }
    }

    var zoneDetails: ZoneDetails? {
        didSet {
            selectedRecord = nil
            sortRecords()
            notifyDelegate()
        }
    }

    var records = [DNSRecordResponse]()

    private override init() {}

    private func sortRecords() {
        guard let unsortedRecords = zoneDetails?.records else { return }
        records = unsortedRecords.sorted { $0.name < $1.name }
    }

    private func notifyDelegate() {
        guard let name = zoneDetails?.name else { return }
        delegate?.recordWasUpdated(name)
    }
}

extension DNSRecordDataManager: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return zoneDetails?.records.count ?? 0
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let record = records[row]
        let identifier = NSUserInterfaceItemIdentifier("RecordCell")
        guard let cell = tableView.makeView(withIdentifier: identifier, owner: self) as? RecordCell else { return nil }

        cell.record = record
        return cell
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let tableView = notification.object as? NSTableView else { return }
        print(tableView.selectedRow)
        selectedRecord = records[tableView.selectedRow]
    }
}
