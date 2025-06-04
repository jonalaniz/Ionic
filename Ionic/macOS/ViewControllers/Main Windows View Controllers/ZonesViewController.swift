//
//  ZonesViewController.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/11/25.
//

import Cocoa

class ZonesViewController: MainWindowViewController {
    @IBOutlet weak var zoneTableView: NSTableView!

    let zoneManager = ZoneDataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        zoneTableView.dataSource = zoneManager
        zoneTableView.delegate = zoneManager
    }

    override func zonesReloaded() {
        let selectedRow = zoneTableView.selectedRow
        zoneTableView.reloadData()

        if zoneTableView.numberOfRows > selectedRow {
            let indexSet = IndexSet(integer: selectedRow)
            zoneTableView.selectRowIndexes(indexSet, byExtendingSelection: false)
        }
    }
}
