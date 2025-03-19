//
//  DynamicDNSDataManager.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/18/25.
//

import Cocoa

protocol DynamicDNSDataManagerDelegate: NSObject {
    func selectionDidChange()
    func urlCaptured(_ urlString: String)
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
        let dynamicDNSRequest = DynamicDNSRequest(domains: selectedDomains, description: "Ionic DNS")

        delegate?.urlCaptured("https://ipv4.api.hosting.ionos.com/dns/v1/dyndns?q=MWVmYWU2OGJmYjNmNGYyNmEyNDBkNWM5Y2Q4YmYxNzcuVkNWZnk2N25EVjhhM2tUbkVpd1cydll4VjBOM2RyOU5JT0FCVFJtZ1ozR1hQVW1qUzBHNUJpb2lERXdjRnJZaTR4eFZPeEhWYU1sYnpidEhiWDVydlE")
        print(dynamicDNSRequest)
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
