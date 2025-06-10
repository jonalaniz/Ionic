//
//  DynamicDNSDataManager.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/18/25.
//

import Cocoa

class DynamicDNSDataManager: BaseDataManager {
    // MARK: - Singleton

    static let shared = DynamicDNSDataManager()
    private init() { super.init(source: .ddnsDataManager) }

    // MARK: - Properties

    weak var delegate: DynamicDNSDataManagerDelegate?

    var domainNames: [String]?

    // MARK: - Zone Handling

    // Extracts A records hostnames
    func parse(records: [RecordResponse], in domain: String) {
        var names: Set<String> = []
        names.insert(domain)
        records.forEach {
            if $0.type == .A || $0.type == .AAAA {
                names.insert($0.name)
            }
        }

        let domainArray = Array(names).sorted()
        domainNames = domainArray
    }

    func fetchDynamicDNSURL(for indexSet: IndexSet) {
        guard let domains = domainNames else { return }
        let selectedDomains = indexSet.map { domains[$0] }
        let dynamicDNSRequest = DynamicDNSRequest(domains: selectedDomains, description: "Ionic DNS")

        Task {
            do {
                let response  = try await service.postDynamicDNSRecord(dynamicDNSRequest)
                await urlCaptured(response.updateUrl)
            } catch {
                handleError(error)
            }
        }
    }

    // MARK: - Helper Methods

    @MainActor
    func urlCaptured(_ urlString: String) {
        delegate?.urlCaptured(urlString)
    }
}

// MARK: - NSTableViewDataSource & Delegate

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
