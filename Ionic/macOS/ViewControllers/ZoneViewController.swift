//
//  ZoneView.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/11/25.
//

import Cocoa

class ZoneViewController: NSViewController {
    @IBOutlet weak var zoneTableView: NSTableView!

    let dataManager = ZoneDataManager.shared
    let recordDataManager = DNSRecordDataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.delegate = self
        zoneTableView.dataSource = self
        zoneTableView.delegate = self
    }
}

extension ZoneViewController: ZoneDataManagerDelegate {
    func stateDidChange(_ state: ZoneDataManagerState) {
        // Nothing right now, this functionality was moved to the Toolbar
    }
}

extension ZoneViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let column = Column(from: tableColumn?.identifier) else { return nil }
        let cellIdentifier = NSUserInterfaceItemIdentifier(column.cellIdentifier)

        guard let cell = tableView.makeView(
            withIdentifier: cellIdentifier,
            owner: self) as? NSTableCellView
        else { return NSTableCellView() }

        cell.textField?.stringValue = dataManager.zones[row].name
        cell.imageView?.image = image(for: dataManager.zones[row].type)

        return cell
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedZone = dataManager.zones[zoneTableView.selectedRow]
        recordDataManager.zoneDetails = dataManager.zoneDetails[selectedZone.id]
    }

    private func image(for type: ZoneType) -> NSImage? {
        return NSImage(systemSymbolName: type.sfSymbolName, accessibilityDescription: "")
    }
}

extension ZoneViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataManager.zones.count
    }
}
