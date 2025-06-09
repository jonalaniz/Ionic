//
//  DNSDataManagerCoordinator.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/31/25.
//

import Foundation

/// `DNSDataManagerCoordinator` is a central orchestrator for synchronizing state across
/// multiple DNS-related data managers, including zone, record, and dynamic DNS managers.
///
/// It serves as a bridge between the `APIKeyManager` and the managers that load or manipulate
/// DNS data. It also handles broadcasting system-wide notifications for view controllers to
/// observe data changes without tightly coupling the layers.
class DNSDataManagerCoordinator: NSObject {
    // MARK: - Shared Instance

    /// Shared singleton instance of the coordinator.
    static let shared = DNSDataManagerCoordinator()

    // MARK: - Properties

    /// The currently active API key. This is the key used to authenticate all API calls.
    var apiKey: DNSAPIKey? {
        return apiKeyManager.key
    }

    /// Handles storing and retrieving the current API key.
    private let apiKeyManager = APIKeyManager.shared

    /// Manages domain names and update URLs used for Dynamic DNS functionality.
    private let ddnsDataManager = DynamicDNSDataManager.shared

    /// Manages the currently selected zone's DNS records.
    private let recordDataManager = RecordDataManager.shared

    /// Manages fetching and storing DNS zones.
    private let zoneDataManager = ZoneDataManager.shared

    // MARK: - Lifecycle

    /// Private initializer that also sets up delegate communication with other data managers.
    private override init() {
        super.init()
        zoneDataManager.delegate = self
        recordDataManager.delegate = self
    }

    // MARK: - Public Methods

    /// Establishes a connection with the API using the provided key, and optionally saves it.
    /// - Parameters:
    ///   - key: The `DNSAPIKey` containing the public/private credentials.
    ///   - save: Whether the key should be persisted in the Keychain.
    func connect(with key: DNSAPIKey, save: Bool) {
        apiKeyManager.addKey(key, save: save)
        loadInitialData()
    }

    /// Initiates reloading of DNS zones. Errors are handled by `ZoneDataManager`.
    func reloadZones() {
        guard zoneDataManager.zonesLoaded else { return }
        post(notification: .zonesReloading)

        Task {
            try? await zoneDataManager.reloadZones()
        }
    }

    // MARK: - Helper Methods

    /// Initiates loading of DNS zones. Errors are handled by `ZoneDataManager`.
    private func loadInitialData() {
        Task {
            try? await zoneDataManager.loadData()
        }
    }

    /// Convenience method for posting system-wide notifications on the main thread.
    /// - Parameter notification: The `Notification.Name` to broadcast.
    private func post(notification: Notification.Name) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: notification,
                object: nil)
        }
    }
}

// MARK: - ZoneDataManagerDelegate

extension DNSDataManagerCoordinator: ZoneDataManagerDelegate {

    /// Called when zone data has been loaded.
    /// Posts `.zonesDidChange` notification and refreshes Dynamic DNS data.
    func zonesLoaded() {
        post(notification: .zonesDidChange)
    }

    func zonesReloaded() {
        post(notification: .zonesDidReload)
    }

    /// Called when zone has been selected
    func selected(_ zone: ZoneDetails) {
        recordDataManager.select(zone: zone)
    }
}

// MARK: - DNSRecordDataManagerDelegate

extension DNSDataManagerCoordinator: RecordDataManagerDelegate {
    func stateDidChange(_ state: RecordDataManagerState) {
        guard let zone = recordDataManager.selectedZone?.name else { return }
        switch state {
        case .zoneSelected:
            post(notification: .selectedZoneDidChange)
            ddnsDataManager.parse(records: recordDataManager.records, in: zone)
        case .recordCreated:
            post(notification: .recordCreated)
            ddnsDataManager.parse(records: recordDataManager.records, in: zone)
        case .recordDeleted:
            post(notification: .selectedRecordWasDeleted)
        case .recordSelected:
            post(notification: .selectedRecordDidChange)
        case .recordUpdated:
            post(notification: .selectedRecordUpdated)
        }
    }

    func updateZoneDetail(_ zone: ZoneDetails) {
        zoneDataManager.update(zone: zone)
    }
}
