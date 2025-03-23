//
//  IONOS DataManager.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/9/25.
//

import Foundation

enum DataManagerState {
    case uninitialized
    case loading
    case done
}

class IONOSDataManager {
    static let shared = IONOSDataManager()
    weak var delegate: IONOSDataManagerDelegate?

    private let service = IONOSService.shared
    private var apiKey: String?
    var zones = [Zone]()
    var zoneDetails = [String: ZoneDetails]()

    private init() {}

    @MainActor func setKeys(publicKey: String, privateKey: String) {
        apiKey = publicKey + "." + privateKey
        loadData()
    }

    @MainActor func loadData() {
        stateDidChange(.loading)
        Task {
            await loadZones()
            await loadZoneInformation()
            NotificationCenter.default.post(name: .zonesDidChange, object: nil)
            stateDidChange(.done)
        }
    }

    func loadZones() async {
        guard let apiKey = apiKey else { return }
        do {
            zones = try await service.fetchZoneList(with: apiKey)
        } catch {
            print(error)
        }
    }

    func loadZoneInformation() async {
        guard let apiKey = apiKey else { return }

        for zone in zones {
            do {
                let zoneDetail = try await service.fetchZoneDetail(id: zone.id, with: apiKey)
                zoneDetails[zone.id] = zoneDetail
            } catch {
                print("Error")
            }
        }
    }

    @MainActor
    func stateDidChange(_ state: DataManagerState) {
        delegate?.stateDidChange(state)
    }
}

protocol IONOSDataManagerDelegate: NSObject {
    func stateDidChange(_ state: DataManagerState)
}
