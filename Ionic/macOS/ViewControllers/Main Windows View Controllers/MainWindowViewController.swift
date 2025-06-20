//
//  MainWindowViewController.swift
//  Ionic
//
//  Created by Jon Alaniz on 5/12/25.
//

import Cocoa

/// `MainWindowViewController` is a base view controller for all view controllers
/// in the main window. It listens to zone and record update notifications and
/// provides overridable methods for responding to them.
class MainWindowViewController: NSViewController {
    // MARK: - Properties

    /// Shared DNS record manager used to access and update zone and record data.
    let recordManager = RecordDataManager.shared

    // MARK: - Lifecycle

    /// Called after the view has been loaded into memory.
    ///
    /// Subscribes the view controller to relevant DNS zone and record notifications.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotifications()
    }

    /// Called when the view controller is deallocated.
    ///
    /// Ensures the controller is removed as an observer from `NotificationCenter`.
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Configuration

    /// Subscribes the view controller to zone and record update notifications.
    private func setupNotifications() {
        subscribeTo(.recordCreated, with: #selector(recordCreated))
        subscribeTo(.selectedRecordDidChange, with: #selector(recordSelected))
        subscribeTo(.selectedZoneDidChange, with: #selector(zoneUpdated))
        subscribeTo(.selectedRecordUpdated, with: #selector(recordUpdated))
        subscribeTo(.selectedRecordWasDeleted, with: #selector(recordDeleted))
        subscribeTo(.zonesReloading, with: #selector(zonesReloading))
        subscribeTo(.zonesDidChange, with: #selector(zonesUpdated))
        subscribeTo(.zonesDidReload, with: #selector(zonesReloaded))
    }

    // MARK: - Notification Handlers

    /// Called when a record has been successfully created..
    ///
    /// Subclasses can override this method to respond to selection changes.
    @objc func recordCreated() {}

    /// Called when a record has been selected.
    ///
    /// Subclasses can override this method to respond to selection changes.
    @objc func recordSelected() {}

    /// Called when a the selected record was deleted..
    ///
    /// Subclasses can override this method to respond to selection changes.
    @objc func recordDeleted() {}

    /// Called when a record has been updated.
    ///
    /// Subclasses can override this to refresh the UI or take other actions.
    @objc func recordUpdated() {}

    /// Called when the zones list has changed (e.g., added or removed).
    ///
    /// Subclasses can override to update views as needed.
    @objc func zonesUpdated() {}

    /// Called when the zones begin reloading.
    ///
    /// Subclasses can override to show loading indicators or placeholders.
    @objc func zonesReloading() {}

    /// Called when the zones have finished reloading.
    ///
    /// Subclasses can override to refresh the UI with the latest data.
    @objc func zonesReloaded() {}

    /// Called when the selected zone has been updated.
    ///
    /// Subclasses can override to update their views accordingly.
    @objc func zoneUpdated() {}

    // MARK: - Helper Methods
    private func subscribeTo(_ name: Notification.Name, with selector: Selector) {
        NotificationCenter.default.addObserver(
            self,
            selector: selector,
            name: name,
            object: nil)
    }
}
