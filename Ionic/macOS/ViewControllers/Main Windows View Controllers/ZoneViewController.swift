//
//  ZoneViewController.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Cocoa

// ZoneViewController controls the middle view in
// the main window. Displays a table of records in
// the zone.
class ZoneViewController: MainWindowViewController {
    @IBOutlet weak var detailTableView: NSTableView!
    @IBOutlet weak var zoneNameLabel: NSTextField!
    @IBOutlet weak var createRecordButton: NSButton!
    @IBOutlet weak var dynamicDNSButton: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.dataSource = recordManager
        detailTableView.delegate = recordManager
    }

    override func zonesReloaded() {
        print("ZoneViewController: zonesReloaded ")
        zoneUpdated()
    }

    override func zoneUpdated() {
        guard let zoneDetails = recordManager.selectedZone else { return }
        zoneNameLabel.stringValue = zoneDetails.name
        detailTableView.reloadData()
        detailTableView.scrollRowToVisible(0)
        createRecordButton.isEnabled = true

        // Only enable the button if the zone has an A or AAAA record
        if zoneDetails.records.contains(where: { $0.type == .A || $0.type == .AAAA }) {
            dynamicDNSButton.isEnabled = true
        }
    }

    override func recordUpdated() {
        guard
            let record = recordManager.selectedRecord,
            let row = recordManager.records.firstIndex(where: { $0.id == record.id })
        else { return }

        // grab the specific cell related to that selection
        detailTableView.reloadData(forRowIndexes: IndexSet(integer: row), columnIndexes: IndexSet(integer: 0))
    }
}
