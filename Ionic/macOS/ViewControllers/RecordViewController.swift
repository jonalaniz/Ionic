//
//  ViewController.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Cocoa

class RecordViewController: NSViewController {
    @IBOutlet weak var detailTableView: NSTableView!
    @IBOutlet var zoneNameLabel: NSTextField!

    let recordDataManager = DNSRecordDataManager.shared

    var inspectorSplitViewItem: NSSplitViewItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        recordDataManager.delegate = self

        detailTableView.dataSource = recordDataManager
        detailTableView.delegate = recordDataManager
    }

    override func viewWillAppear() {}
}

extension RecordViewController: DNSRecordDataManagerDelegate {
    func recordWasUpdated(_ recordName: String) {
        zoneNameLabel.stringValue = recordName
        detailTableView.reloadData()
    }
}
