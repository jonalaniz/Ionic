//
//  NSRecordDataManager.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/10/25.
//

import Cocoa

class DNSRecordDataManager: BaseDataManager {
    static let shared = DNSRecordDataManager()
    weak var delegate: DNSRecordDataManagerDelegate?

    var selectedRecord: RecordResponse?

    private(set) var selectedZone: ZoneDetails?

    var records: [RecordResponse] {
        return selectedZone?.records.sorted {
            $0.name < $1.name
        } ?? []
    }

    private init() { super.init(source: .recordDataManager) }

    func createRecord(name: String, type: RecordType, content: String, ttl: TTL, prio: Int?) {
        guard
            let zoneID = selectedZone?.id,
            let zone = selectedZone?.name
        else { return }

        // The `name` that the API expects is the hostName + the domain (www.example.com)
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
                let response = try await service.update(
                    record: object,
                    zoneID: zoneID,
                    recordID: record.id
                )
                applyUpdated(record: response)
            } catch {
                handleError(error)
            }
        }
    }

    func select(zone: ZoneDetails) {
        selectedZone = zone
        selectedRecord = nil
        notifyDelegate(.zoneSelected)
    }

    // MARK: - Helper Methods
    private func add(_ record: [RecordResponse]) {
        guard
            let zone = selectedZone,
            let newRecord = record.first
        else { return }

        selectedRecord = newRecord
        var updatedRecords = records
        updatedRecords.append(newRecord)
        updatedRecords.sort(by: { $0.name < $1.name })

        // TODO: The zone array may need to be updated, if we click the zone again, it might not have
        // the new records.
        selectedZone = zone.withUpdatedRecords(updatedRecords)
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
    private func removeRecordFromSelectedZone(recordID: String) {
        guard let zone = selectedZone else { return }
        var updatedRecords = zone.records
        updatedRecords.removeAll(where: { $0.id == recordID })

        selectedZone = zone.withUpdatedRecords(updatedRecords)
    }

    private func notifyDelegate(_ state: DNSRecordDataManagerState) {
        DispatchQueue.main.async {
            self.delegate?.stateDidChange(state)
        }
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
        let index = tableView.selectedRow
        guard records.indices.contains(index) else { return }
        selectedRecord = records[index]
        notifyDelegate(.recordSelected)
    }
}
