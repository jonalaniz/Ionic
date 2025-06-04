//
//  IONOS DataManager.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/9/25.
//

import Cocoa

protocol ZoneDataManagerDelegate: AnyObject {
    /// Called when Zones were fetched and parsed successfully
    func zonesLoaded()

    func zonesReloaded()

    func selected(_ zone: ZoneDetails)
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

    @MainActor func reloadZones() throws {
        Task {
            await loadZoneInformation()

            guard !zoneDetails.isEmpty else {
                errorHandler?.handle(error: .conversionFailedToHTTPURLResponse, from: source)
                return
            }

            // Let the coordinator know what we have done
            zonesReloaded()
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

    @MainActor
    func zonesReloaded() {
        delegate?.zonesReloaded()
    }

    func select(_ zone: ZoneDetails) {
        delegate?.selected(zone)
    }
}

extension ZoneDataManager: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return zones.count
    }
}
