//
//  ZoneViewController.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Cocoa

/// `ZoneViewController` controls the middle view of the main window.
///
/// It displays the records for the currently selected DNS zone in a table view.
/// This controller updates the UI in response to zone and record changes.
class ZoneViewController: MainWindowViewController {
    // MARK: - Outlets

    @IBOutlet weak var detailTableView: NSTableView!
    @IBOutlet weak var zoneNameLabel: NSTextField!
    @IBOutlet weak var loadingIndicator: NSProgressIndicator!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.dataSource = recordManager
        detailTableView.delegate = recordManager
    }

    // MARK: - Notification Handlers

    /// Called when zones begin reloading.
    ///
    /// Starts the loading indicator animation.
    override func zonesReloading() {
        loadingIndicator.startAnimation(nil)
    }

    /// Called when zones have finished reloading.
    ///
    /// Triggers the UI update with the current selected zone.
    override func zonesReloaded() {
        zoneUpdated()
    }

    /// Called when the selected zone is updated.
    ///
    /// Updates the UI with the new zone's name, records, and relevant button states.
    override func zoneUpdated() {
        loadingIndicator.stopAnimation(nil)
        detailTableView.reloadData()
        detailTableView.scrollRowToVisible(0)
    }

    /// Called when a new record is created.
    ///
    /// Updates the UI with the new record and checks for A records for Dynamic DNS Button.
    override func recordCreated() {
        detailTableView.reloadData()
        guard
            let selectedRecord = recordManager.selectedRecord,
            let index = recordManager.records.firstIndex(where: { $0.id ==  selectedRecord.id })
        else { return }
        let indexSet = IndexSet(integer: index)
        detailTableView.selectRowIndexes(indexSet, byExtendingSelection: false)
        detailTableView.scrollRowToVisible(index)
    }

    /// Called when a new record is created.
    ///
    /// Reselects row in `detailTableView` and updates UI
    override func recordDeleted() {
        // Grab the last selected row
        let selectedRow = detailTableView.selectedRow
        detailTableView.reloadData()
        guard selectedRow <= detailTableView.numberOfRows else { return }
        detailTableView.selectRowIndexes(IndexSet(integer: selectedRow), byExtendingSelection: false)
    }

    /// Called when a specific record has been updated.
    ///
    /// Reloads only the affected row in the table view for performance and clarity.
    override func recordUpdated() {
        guard
            let record = recordManager.selectedRecord,
            let row = recordManager.records.firstIndex(where: { $0.id == record.id })
        else { return }

        // Reload only the affected row in the first column
        detailTableView.reloadData(
            forRowIndexes: IndexSet(integer: row),
            columnIndexes: IndexSet(integer: 0)
        )
    }
}
