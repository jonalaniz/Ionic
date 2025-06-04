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

    /// Shared singleton instance of the coordinator.
    static let shared = DNSDataManagerCoordinator()

    /// Handles storing and retrieving the current API key.
    private let apiKeyManager = APIKeyManager.shared

    /// Manages fetching and storing DNS zones.
    let zoneDataManager = ZoneDataManager.shared

    /// Manages the currently selected zone's DNS records.
    let recordDataManager = DNSRecordDataManager.shared

    /// Manages domain names and update URLs used for Dynamic DNS functionality.
    let ddnsDataManager = DynamicDNSDataManager.shared

    /// Manages creation of new DNS Records in a specified zone.
    let recordFactory = RecordFactory.shared

    /// The currently active API key. This is the key used to authenticate all API calls.
    var apiKey: DNSAPIKey? {
        return apiKeyManager.key
    }

    /// Private initializer that also sets up delegate communication with other data managers.
    private override init() {
        super.init()
        zoneDataManager.delegate = self
        recordDataManager.delegate = self
    }

    /// Establishes a connection with the API using the provided key, and optionally saves it.
    /// - Parameters:
    ///   - key: The `DNSAPIKey` containing the public/private credentials.
    ///   - save: Whether the key should be persisted in the Keychain.
    func connect(with key: DNSAPIKey, save: Bool) {
        apiKeyManager.addKey(key, save: save)
        loadInitialData()
    }

    func reloadZones() {
        Task {
            try? await zoneDataManager.reloadZones()
        }
    }

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
        recordFactory.domain = zone.name
    }
}

// MARK: - DNSRecordDataManagerDelegate
extension DNSDataManagerCoordinator: DNSRecordDataManagerDelegate {
    /// Called when a zone is selected.
    func zoneSelected() {
        post(notification: .selectedZoneDidChange)
        ddnsDataManager.parse(records: recordDataManager.records)
    }

    /// Called when a record is selected in the UI.
    func recordSelected() {
        post(notification: .selectedRecordDidChange)
    }

    /// Called when a record is updated (e.g., modified or disabled).
    func recordUpdated() {
        post(notification: .selectedRecordUpdated)
    }
}
