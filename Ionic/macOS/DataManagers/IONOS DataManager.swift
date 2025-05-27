//
//  IONOS DataManager.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/9/25.
//

import Cocoa

protocol ZoneDataManagerDelegate: NSObject {
    /// Called when Zones were fetched and parsed successfully
    func zonesLoaded()
}

class ZoneDataManager: BaseDataManager {
    static let shared = ZoneDataManager()
    weak var delegate: ZoneDataManagerDelegate?

    var zones = [Zone]()
    var zoneDetails = [String: ZoneDetails]()

    private init() {
        super.init(source: .zoneDataManager)
    }

    @MainActor func loadData() throws {
        Task {
            await loadZones()
            await loadZoneInformation()
            
            // Make sure the above was successful, errors will be thrown above
            guard !zones.isEmpty, !zoneDetails.isEmpty else {
                print("Shit's empty")
                return
            }
                        
            // Let the coordinator know we are done
            zonesLoaded()
        }
    }

    func loadZones() async {
        do {
            zones = try await service.fetchZoneList()
        } catch {
            handleError(error)
        }
    }

    func loadZoneInformation() async {
        for zone in zones {
            do {
                let zoneDetail = try await service.fetchZoneDetail(id: zone.id)
                zoneDetails[zone.id] = zoneDetail
            } catch {
                handleError(error)
            }
        }
    }

    @MainActor
    func zonesLoaded() {
        delegate?.zonesLoaded()
    }
}

extension ZoneDataManager: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return zones.count
    }
}
