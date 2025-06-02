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
        zoneTableView.delegate = self
    }
}

extension ZonesViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let identifier = NSUserInterfaceItemIdentifier("ZoneCell")
        guard let cell = tableView.makeView(
            withIdentifier: identifier,
            owner: self) as? NSTableCellView
        else { return NSTableCellView() }

        cell.textField?.stringValue = zoneManager.zones[row].name
        cell.imageView?.image = image(for: zoneManager.zones[row].type)
        cell.imageView?.toolTip = zoneManager.zones[row].type.description

        return cell
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedZone = zoneManager.zones[zoneTableView.selectedRow]
        guard let zone = zoneManager.zoneDetails[selectedZone.id] else { return }
        zoneManager.select(zone)
    }

    private func image(for type: ZoneType) -> NSImage? {
        return NSImage(systemSymbolName: type.sfSymbolName, accessibilityDescription: "")
    }
}
