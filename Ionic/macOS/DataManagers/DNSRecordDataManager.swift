//
//  NSRecordDataManager.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/10/25.
//

import Cocoa

protocol DNSRecordDataManagerDelegate: NSObject {
    func zoneUpdated()
    func recordUpdated()
}

// TODO: Implement error handling like that form the other DataManagers
// Maybe create a base datamanager class??? 🤔
// We can set the type in the data manager and pass it to a shared
// errorHandler function as well as make it overridable if something
// must be haulted in the future
class DNSRecordDataManager: NSObject {
    static let shared = DNSRecordDataManager()
    weak var delegate: DNSRecordDataManagerDelegate?
    weak var errorHandler: ErrorHandling?

    let service = IONOSService.shared

    var selectedRecord: RecordResponse?

    var selectedZone: ZoneDetails? {
        didSet {
            selectedRecord = nil
            sortRecords()
            delegate?.zoneUpdated()
        }
    }

    var records = [RecordResponse]()

    private override init() {}

    func toggleDisabledStatus() {
        guard
            let record = selectedRecord,
            let zoneID = selectedZone?.id
        else {
            print("unable to grab record: \(String(describing: selectedRecord)), \(String(describing: selectedZone?.id))")
            return
        }

        // Create the record update object
        let object = RecordUpdate(disabled: !record.disabled,
                                  content: record.content,
                                  ttl: record.ttl,
                                  prio: record.prio ?? 0)

        Task {
            do {
                let response = try await service.update(record: object, zoneID: zoneID, recordID: record.id)
                selectedRecord = response

                if let index = records.firstIndex(where: { $0.id == response.id }) {
                    records[index] = response
                    delegate?.recordUpdated()
                }

            } catch {
                errorHandler?.handle(error: error as! APIManagerError, from: .recordDataManager)
            }
        }
    }

    private func sortRecords() {
        guard let unsortedRecords = selectedZone?.records else { return }
        records = unsortedRecords.sorted { $0.name < $1.name }
    }
}

extension DNSRecordDataManager: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return selectedZone?.records.count ?? 0
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let record = records[row]
        let identifier = NSUserInterfaceItemIdentifier("RecordCell")
        guard let cell = tableView.makeView(withIdentifier: identifier, owner: self) as? RecordCell
        else { return nil }

        cell.record = record
        return cell
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let tableView = notification.object as? NSTableView else { return }
        selectedRecord = records[tableView.selectedRow]
        delegate?.recordUpdated()
    }
}
