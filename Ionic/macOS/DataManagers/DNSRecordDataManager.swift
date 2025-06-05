//
//  NSRecordDataManager.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/10/25.
//

import Cocoa

// TODO: Change this to state and enum
protocol DNSRecordDataManagerDelegate: AnyObject {
    func zoneSelected()
    func recordDeleted()
    func recordSelected()
    func recordUpdated()
}

class DNSRecordDataManager: BaseDataManager {
    static let shared = DNSRecordDataManager()
    weak var delegate: DNSRecordDataManagerDelegate?

    var selectedRecord: RecordResponse?

    private(set) var selectedZone: ZoneDetails? {
        didSet {
            print(self.records.count)
        }
    }

    var records: [RecordResponse] {
        return selectedZone?.records.sorted {
            $0.name < $1.name
        } ?? []
    }

    private init() {
        super.init(source: .recordDataManager)
    }

    // TODO: factor out Zone updating
    func deleteRecord() {
        guard
            let recordID = selectedRecord?.id,
            let zoneID = selectedZone?.id
        else {
            handleError(APIManagerError.configurationMissing)
            return
        }

        Task {
            do {
                try await service.delete(record: recordID, in: zoneID)

                guard let oldZone = selectedZone else { return }

                var oldRecords = oldZone.records

                if let index = selectedZone?.records.firstIndex(where: {$0.id == recordID}) {
                    oldRecords.remove(at: index)
                    selectedZone = ZoneDetails(
                        id: oldZone.id,
                        name: oldZone.name,
                        type: oldZone.type,
                        records: oldRecords
                    )
                }

                delegate?.recordDeleted()
            } catch {
                handleError(error)
            }
        }
    }

    func toggleDisabledStatus() {
        guard
            let record = selectedRecord,
            let zoneID = selectedZone?.id
        else {
            handleError(APIManagerError.configurationMissing)
            return
        }

        // Create the record update object
        let object = RecordUpdate(
            disabled: !record.disabled,
            content: record.content,
            ttl: record.ttl,
            prio: record.prio ?? 0)

        Task {
            do {
                let response = try await service.update(record: object, zoneID: zoneID, recordID: record.id)
                selectedRecord = response

                updateRecord(with: response)
            } catch {
                handleError(error)
            }
        }
    }

    func select(zone: ZoneDetails) {
        selectedZone = zone
        selectedRecord = nil
        delegate?.zoneSelected()
    }

    private func updateRecord(with response: RecordResponse) {
        selectedRecord = response

        guard let oldZone = selectedZone else { return }

        var oldRecords = records
        if let index = oldRecords.firstIndex(where: {
            $0.id == response.id
        }) {
            oldRecords[index] = response
        }

        selectedZone = ZoneDetails(
            id: oldZone.id,
            name: oldZone.name,
            type: oldZone.type,
            records: oldRecords
        )

        delegate?.recordUpdated()
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
        delegate?.recordSelected()
    }
}
