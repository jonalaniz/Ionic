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
        zoneTableView.dataSource = zoneManager
        zoneTableView.delegate = zoneManager
    }

    // MARK: - Notification Handlers

    override func zonesReloaded() {
        let selectedRow = zoneTableView.selectedRow
        zoneTableView.reloadData()

        if zoneTableView.numberOfRows > selectedRow {
            let indexSet = IndexSet(integer: selectedRow)
            zoneTableView.selectRowIndexes(indexSet, byExtendingSelection: false)
        }
    }
}
