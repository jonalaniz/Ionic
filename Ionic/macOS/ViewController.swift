//
//  ViewController.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var outlineView: NSOutlineView!

    let dataManager = IONOSDataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.delegate = self
        outlineView.dataSource = self
        outlineView.delegate = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

extension ViewController: IONOSDataManagerDelegate {
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
            outlineView.reloadData()
        }
    }
}

extension ViewController: NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard
            let tableColumn = tableColumn,
            let column = Column(from: tableColumn.identifier)
        else {
            return nil
        }

        let cellIdentifier = NSUserInterfaceItemIdentifier(column.cellIdentifier)

        guard let cell = outlineView.makeView(
            withIdentifier: cellIdentifier,
            owner: self) as? NSTableCellView
        else {
            return NSTableCellView()
        }

        if let textField = cell.textField {
            switch column {
            case .Zone: textField.stringValue = (item as? Zone)?.name ?? "NO DATA"
            case .ID: textField.stringValue = (item as? Zone)?.id ?? "NO DATA"
            case .ZoneType: textField.stringValue = (item as? Zone)?.type ?? "NO DATA"
            }
        }

        return cell
    }

    func outlineViewSelectionDidChange(_ notification: Notification) {
        let selectionItem = outlineView.item(atRow: outlineView.selectedRow)
        if let selectedZone = selectionItem as? Zone {
            // Here is where we will load the tableview data manager
            print(dataManager.zoneDetails[selectedZone.id])
        }
    }

    func outlineView(_ outlineView: NSOutlineView, didClick tableColumn: NSTableColumn) {

    }
}

extension ViewController: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return dataManager.zones.count
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return dataManager.zones[index]
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        false
    }
}
