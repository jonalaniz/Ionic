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
    weak var errorHandler: ErrorHandling?

    private let service = IONOSService.shared
    var zones = [Zone]()
    var zoneDetails = [String: ZoneDetails]()

    private override init() {}

    @MainActor func loadData() throws {
        stateDidChange(.loading)
        Task {
            await loadZones()
            await loadZoneInformation()
            
            // Make sure the above was successful, errors will be thrown above
            guard !zones.isEmpty, !zoneDetails.isEmpty else {
                print("Shit's empty")
                return
            }
            
            // Notify that the zones were changed
            NotificationCenter.default.post(name: .zonesDidChange, object: nil)
            
            // Let the coordinator know we are done
            stateDidChange(.done)
        }
    }

    func loadZones() async {
        print("loading Zones")
        do {
            zones = try await service.fetchZoneList()
        } catch {
            handleError(error)
        }
    }

    func loadZoneInformation() async {
        print("Loading Zone information")
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
    func stateDidChange(_ state: ZoneDataManagerState) {
        delegate?.stateDidChange(state)
    }
    
    private func handleError(_ error: Error) {
        guard let apiError = error as? APIManagerError else {
            errorHandler?.handle(
                error: APIManagerError.somethingWentWrong(error: error),
                from: .zoneDataManager
            )
            return
        }
                
        errorHandler?.handle(error: apiError, from: .zoneDataManager)
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
