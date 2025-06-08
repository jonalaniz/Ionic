//
//  ZonesViewController.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/11/25.
//

import Cocoa

class ZonesViewController: MainWindowViewController {
    // MARK: - Outlets

    @IBOutlet weak var zoneTableView: NSTableView!

    // MARK: - Properties

    private let zoneManager = ZoneDataManager.shared

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        selectFirstRowIfNeeded()
    }

    // MARK: - Configuration
    private func configureTableView() {
        zoneTableView.dataSource = zoneManager
        zoneTableView.delegate = zoneManager
    }

    private func selectFirstRowIfNeeded() {
        guard zoneTableView.numberOfRows > 0 else { return }
        zoneTableView.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
    }

    // MARK: - Notification Handlers

    /// Called when the zones are reloaded.
    /// Attempts to reselect the previously selected row.
    override func zonesReloaded() {
        let selectedRow = zoneTableView.selectedRow
        zoneTableView.reloadData()

        if zoneTableView.numberOfRows > selectedRow {
            let indexSet = IndexSet(integer: selectedRow)
            zoneTableView.selectRowIndexes(indexSet, byExtendingSelection: false)
        }
    }
}
