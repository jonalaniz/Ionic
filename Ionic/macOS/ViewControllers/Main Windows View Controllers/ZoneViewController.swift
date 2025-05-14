//
//  ViewController.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Cocoa

class ZoneViewController: NSViewController {
    @IBOutlet weak var detailTableView: NSTableView!
    @IBOutlet var zoneNameLabel: NSTextField!
    @IBOutlet weak var dynamicDNSButton: NSButton!
    
    let recordDataManager = DNSRecordDataManager.shared
    let dynamicDNSDataManager = DynamicDNSDataManager.shared

    var inspectorSplitViewItem: NSSplitViewItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        recordDataManager.delegate = self

        detailTableView.dataSource = recordDataManager
        detailTableView.delegate = recordDataManager
    }

    override func viewWillAppear() {}
}

extension ZoneViewController: DNSRecordDataManagerDelegate {
    func recordWasUpdated(_ zoneName: String) {
        zoneNameLabel.stringValue = zoneName
        detailTableView.reloadData()
        detailTableView.scrollRowToVisible(0)
        dynamicDNSDataManager.parse(records: recordDataManager.records)
        dynamicDNSButton.isEnabled = true
    }
}
