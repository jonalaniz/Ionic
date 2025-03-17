//
//  ZoneView.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/11/25.
//

import Cocoa

class ZoneViewController: NSViewController {
    @IBOutlet weak var zoneTableView: NSTableView!

    let dataManager = IONOSDataManager.shared
    let recordDataManager = DNSRecordDataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.delegate = self
        zoneTableView.dataSource = self
        zoneTableView.delegate = self
    }
}

extension ZoneViewController: IONOSDataManagerDelegate {
    func stateDidChange(_ state: DataManagerState) {
        switch state {
        case .uninitialized: break
        case .loading: isLoading(true)
        case .done: isLoading(false)
        }
    }

    private func isLoading(_ loading: Bool) {
        guard let toolbar = view.window?.toolbar as? Toolbar else { return }
        if loading {
            toolbar.circularProgressView.startAnimation(nil)
        } else {
            toolbar.circularProgressView.stopAnimation(nil)
            zoneTableView.reloadData()
        }
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

        if let textField = cell.textField {
            textField.stringValue = zoneData(for: column, at: row)
        }

        if let imageView = cell.imageView {
            imageView.image = image(for: zoneData(for: .ZoneType, at: row))
        }

        return cell
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedZone = dataManager.zones[zoneTableView.selectedRow]
        recordDataManager.zoneDetails = dataManager.zoneDetails[selectedZone.id]
    }

    private func zoneData(for column: Column, at index: Int) -> String {
        switch column {
        case .Zone: return dataManager.zones[index].name
        case .ID: return dataManager.zones[index].id
        case .ZoneType: return dataManager.zones[index].type
        }
    }

    private func image(for type: String) -> NSImage? {
        return type == "NATIVE" ? NSImage(systemSymbolName: "n.circle", accessibilityDescription: "") : NSImage(systemSymbolName: "s.circle", accessibilityDescription: "")
    }
}

extension ZoneViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataManager.zones.count
    }
}
