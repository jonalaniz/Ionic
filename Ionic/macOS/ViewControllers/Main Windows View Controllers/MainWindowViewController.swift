//
//  MainWindowViewController.swift
//  Ionic
//
//  Created by Jon Alaniz on 5/12/25.
//

import Cocoa

class MainWindowViewController: NSViewController {
    let recordManager = DNSRecordDataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToNotifications()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(recordSelected),
            name: .selectedRecordDidChange,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(zoneUpdated),
            name: .selectedZoneDidChange,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(recordUpdated),
            name: .selectedRecordUpdated,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(zonesUpdated),
            name: .zonesDidChange,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(zonesReloaded),
            name: .zonesDidReload,
            object: nil)
    }

    @objc func recordSelected() {}

    @objc func recordUpdated() {}

    @objc func zonesUpdated() {}

    @objc func zonesReloaded() {}

    @objc func zoneUpdated() {}
}
