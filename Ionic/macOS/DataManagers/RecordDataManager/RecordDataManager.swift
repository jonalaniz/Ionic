//
//  NSRecordDataManager.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/10/25.
//

import Cocoa

class RecordDataManager: BaseDataManager {
    // MARK: - Singleton

    static let shared = RecordDataManager()
    private init() { super.init(source: .recordDataManager) }

    // MARK: - Properties

    weak var delegate: RecordDataManagerDelegate?

    var selectedRecord: RecordResponse?
    private(set) var selectedZone: ZoneDetails?

    var records: [RecordResponse] {
        return selectedZone?.records.sorted {
            $0.name < $1.name
        } ?? []
    }

    // MARK: - Zone Management

    func select(zone: ZoneDetails) {
        selectedZone = zone
        selectedRecord = nil
        notifyDelegate(.zoneSelected)
    }

    // MARK: - Record Creation

    func createRecord(name: String, type: RecordType, content: String, ttl: TTL, prio: Int?) {
        guard
            let zoneID = selectedZone?.id,
            let zone = selectedZone?.name
        else { return }

        // Construct the fully qualified domain name (fqdn).
        let fqdn: String
        if name == "@" || name == "" {
            fqdn = zone
        } else {
            fqdn = "\(name).\(zone)"
        }

        let record = Record(
            name: fqdn,
            type: type,
            content: content,
            ttl: ttl.rawValue,
            prio: prio,
            disabled: false
        )

        Task {
            do {
                let response = try await service.create(
                    record: record,
                    in: zoneID
                )
                add(response)
                notifyDelegate(.recordCreated)
            } catch {
                handleError(error)
            }
        }
    }

    private func add(_ response: [RecordResponse]) {
        guard
            let zone = selectedZone,
            let newRecord = response.first
        else { return }

        selectedRecord = newRecord
        var updatedRecords = records
        updatedRecords.append(newRecord)
        updatedRecords.sort(by: { $0.name < $1.name })

        let newZone =  zone.withUpdatedRecords(updatedRecords)
        selectedZone = newZone
        delegate?.updateZoneDetail(newZone)
    }

    // MARK: - Record Deletion

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
                removeRecordFromSelectedZone(recordID: recordID)
                notifyDelegate(.recordDeleted)
            } catch {
                handleError(error)
            }
        }
    }

    private func removeRecordFromSelectedZone(recordID: String) {
        guard let zone = selectedZone else { return }
        var updatedRecords = zone.records
        updatedRecords.removeAll(where: { $0.id == recordID })

        selectedZone = zone.withUpdatedRecords(updatedRecords)
    }

    // MARK: - Record Updates

    func toggleDisabledStatus() {
        guard let record = selectedRecord else {
            handleError(APIManagerError.configurationMissing)
            return
        }

        updateRecord(
            content: record.content,
            disabled: !record.disabled,
            ttl: record.ttl,
            prio: record.prio ?? 0
        )
    }

    func updateRecord(content: String, disabled: Bool, ttl: Int, prio: Int?) {
        guard
            let record = selectedRecord,
            let zoneID = selectedZone?.id
        else {
            handleError(APIManagerError.configurationMissing)
            return
        }

        let update = RecordUpdate(
            content: content,
            disabled: disabled,
            ttl: ttl,
            prio: prio ?? 0
        )

        postUpdate(update, for: record.id, in: zoneID)
    }

    private func postUpdate(_ update: RecordUpdate, for recordID: String, in zoneID: String) {
        Task {
            do {
                let response = try await service.update(
                    record: update,
                    zoneID: zoneID,
                    recordID: recordID
                )
                applyUpdated(record: response)
            } catch {
                handleError(error)
            }
        }
    }

    private func applyUpdated(record: RecordResponse) {
        guard let zone = selectedZone else { return }

        selectedRecord = record
        var updatedRecords = records
        if let index = updatedRecords.firstIndex(where: { $0.id == record.id }) {
            updatedRecords[index] = record
            selectedZone = zone.withUpdatedRecords(updatedRecords)
        }

        notifyDelegate(.recordUpdated)
    }

    // MARK: - Helper Methods

    private func notifyDelegate(_ state: RecordDataManagerState) {
        DispatchQueue.main.async {
            self.delegate?.stateDidChange(state)
        }
    }
}

// MARK: - NSTableViewDataSource & Delegate

extension RecordDataManager: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return records.count
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
        let row = tableView.selectedRow

        guard records.indices.contains(row) else { return }
        selectedRecord = records[row]
        notifyDelegate(.recordSelected)
    }
}
