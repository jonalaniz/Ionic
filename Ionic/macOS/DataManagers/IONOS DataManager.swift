//
//  IONOS DataManager.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/9/25.
//

import Foundation

enum ZoneDataManagerState {
    case uninitialized
    case loading
    case done
}

class ZoneDataManager {
    static let shared = ZoneDataManager()
    weak var delegate: ZoneDataManagerDelegate?

    private let service = IONOSService.shared
    var zones = [Zone]()
    var zoneDetails = [String: ZoneDetails]()

    private init() {}

    @MainActor func loadData(with key: DNSAPIKey) throws {
        stateDidChange(.loading)
        Task {
            await loadZones(with: key)
            await loadZoneInformation(with: key)
            NotificationCenter.default.post(name: .zonesDidChange, object: nil)
            stateDidChange(.done)
        }
    }

    func loadZones(with key: DNSAPIKey) async {
        do {
            zones = try await service.fetchZoneList(with: key.authenticationString)
        } catch {
            print(error)
        }
    }

    func loadZoneInformation(with key: DNSAPIKey) async {
        for zone in zones {
            do {
                let zoneDetail = try await service.fetchZoneDetail(id: zone.id, with: key.authenticationString)
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

protocol ZoneDataManagerDelegate: NSObject {
    func stateDidChange(_ state: ZoneDataManagerState)
}
