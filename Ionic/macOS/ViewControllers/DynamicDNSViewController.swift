//
//  DynamicDNSViewController.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/17/25.
//

import Cocoa

class DynamicDNSViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var getURLButton: NSButton!
    
    let dataManager = DynamicDNSDataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.delegate = self
        tableView.delegate = dataManager
        tableView.dataSource = dataManager
    }

    @IBAction func getURLPressed(_ sender: Any) {
        guard tableView.selectedRowIndexes.count > 0 else { return }
        dataManager.fetchDynamicDNSURL(for: tableView.selectedRowIndexes)
    }
    
    @IBAction func copyPressed (_ sender: Any) {
    }
}

extension DynamicDNSViewController: DynamicDNSDataManagerDelegate {
    func selectionDidChange() {
        let indexes = tableView.selectedRowIndexes
        getURLButton.isEnabled = indexes.count > 0 ? true : false
    }
}

protocol DynamicDNSDataManagerDelegate: NSObject {
    func selectionDidChange()
}


class DynamicDNSDataManager: NSObject {
    static let shared = DynamicDNSDataManager()
    weak var delegate: DynamicDNSDataManagerDelegate?
    var domainNames: [String]?

    func parse(records: [DNSRecordResponse]) {
        var names = [String]()
        records.forEach {
            if $0.type == .A {
                names.append($0.name)
            }
        }
        domainNames = names
    }

    func fetchDynamicDNSURL(for indexSet: IndexSet) {
        guard let domains = domainNames else { return }
        let selectedDomains = indexSet.map { domains[$0] }
        print(selectedDomains.joined(separator: ", "))
    }
}

extension DynamicDNSDataManager: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return domainNames?.count ?? 0
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let identifier = NSUserInterfaceItemIdentifier("DomainNameCell")
        guard let cell = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView
        else { return NSTableCellView() }

        cell.textField?.stringValue = domainNames?[row] ?? ""
        return cell
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        delegate?.selectionDidChange()
    }
}
