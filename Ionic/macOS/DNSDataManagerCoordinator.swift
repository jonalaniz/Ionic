//
//  DNSDataManagerCoordinator.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/31/25.
//

import Foundation

protocol DNSDataManagerCoordinatorDelegate: NSObject {
    func dnsDataDidUpdate()
    func dynamicDNSDidUpdate(url: String)
}

enum DNSDataManagerCoordinatorState {
    case loading
    case loaded
    case noKeys
    case error
}

class DNSDataManagerCoordinator: NSObject {
    static let shared = DNSDataManagerCoordinator()

    private let apiKeyManager = APIKeyManager.shared

    let zoneDataManager = ZoneDataManager.shared
    let dnsRecordDataManager = DNSRecordDataManager.shared
    let dynamicDNSDataManager = DynamicDNSDataManager.shared

    weak var delegate: DNSDataManagerCoordinatorDelegate?

    var apiKey: DNSAPIKey? {
        return apiKeyManager.key
    }

    private override init() {
        super.init()
        zoneDataManager.delegate = self
        dnsRecordDataManager.delegate = self
    }

    func connect(with key: DNSAPIKey, save: Bool) {
        apiKeyManager.addKey(key, save: save)
        connect()
    }

    private func connect() {
        Task {
            do {
                try await zoneDataManager.loadData()
            } catch {
                print(error)
            }
        }
    }

    private func reloadData() {
        Task {
            do {
                try await zoneDataManager.loadData()
            } catch {
                print(error)
            }
        }
    }

    func fetchDynamicDNS(for indexSet: IndexSet) {
        dynamicDNSDataManager.fetchDynamicDNSURL(for: indexSet)
    }
}

extension DNSDataManagerCoordinator: ZoneDataManagerDelegate {
    func zonesLoaded() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: .zonesDidChange,
                object: nil)
        }

        // Update the DNSDataManager
        dynamicDNSDataManager.parse(records: dnsRecordDataManager.records)
    }
}

extension DNSDataManagerCoordinator: DNSRecordDataManagerDelegate {
    func zoneUpdated() {
        notify(notification: .selectedZoneDidChange)
    }
    
    func recordSelected() {
        notify(notification: .selectedRecordDidChange)
    }
    
    func recordUpdated() {
        notify(notification: .selectedRecordUpdated)
    }
    
    private func notify(notification: Notification.Name) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: notification,
                object: nil)
        }
    }
}
