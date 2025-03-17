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

        configureCollapsableButton()
    }

    override func viewWillAppear() {
        configureCollapsableButton()
    }

    private func configureCollapsableButton() {
        guard
            // Grab our button from the toolbar
            let button = view.window?.toolbar?.items.last?.view as? NSButton,
            // Grab our splitViewController
            let splitViewController = view.window?.contentViewController as? NSSplitViewController,
            // Grab the splitViewITem
            let splitViewItem = splitViewController.splitViewItems.last
        else { return }

        inspectorSplitViewItem = splitViewItem
        button.action = #selector(toggleInspector)

    }

    @objc private func toggleInspector(sender _: NSButton) {
        inspectorSplitViewItem?.animator().isCollapsed.toggle()
    }
}

extension RecordViewController: DNSRecordDataManagerDelegate {
    func recordWasUpdated(_ recordName: String) {
        zoneNameLabel.stringValue = recordName
        detailTableView.reloadData()
    }
}
