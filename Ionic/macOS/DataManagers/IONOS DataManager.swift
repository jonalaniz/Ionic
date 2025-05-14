//
//  IONOS DataManager.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/9/25.
//

import Cocoa

enum ZoneDataManagerState {
    case uninitialized
    case loading
    case done
}

class ZoneDataManager: NSObject {
    static let shared = ZoneDataManager()
    weak var delegate: ZoneDataManagerDelegate?

    private let service = IONOSService.shared
    var zones = [Zone]()
    var zoneDetails = [String: ZoneDetails]()

    private override init() {}

    @MainActor func loadData() throws {
        stateDidChange(.loading)
        Task {
            await loadZones()
            await loadZoneInformation()

            // Notification should change to just notify
            // not pass the data
            NotificationCenter.default.post(name: .zonesDidChange, object: nil)

            // This needs to always go to the Coordinator
            stateDidChange(.done)
        }
    }

    func loadZones() async {
        do {
            zones = try await service.fetchZoneList()
        } catch {
            print(error)
        }
    }

    func loadZoneInformation() async {
        for zone in zones {
            do {
                let zoneDetail = try await service.fetchZoneDetail(id: zone.id)
                zoneDetails[zone.id] = zoneDetail
            } catch {
                print("Error")
            }
        }
    }

    @MainActor
    func stateDidChange(_ state: ZoneDataManagerState) {
        delegate?.stateDidChange(state)
    }
}

extension ZoneDataManager: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return zones.count
    }
}

protocol ZoneDataManagerDelegate: NSObject {
    func stateDidChange(_ state: ZoneDataManagerState)
}
