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

    override func viewDidLoad() {
        super.viewDidLoad()
        recordDataManager.delegate = self

        detailTableView.dataSource = recordDataManager
        detailTableView.delegate = recordDataManager
    }
}

extension RecordViewController: DNSRecordDataManagerDelegate {
    func recordWasUpdated(_ recordName: String) {
        zoneNameLabel.stringValue = recordName
        detailTableView.reloadData()
    }
}
