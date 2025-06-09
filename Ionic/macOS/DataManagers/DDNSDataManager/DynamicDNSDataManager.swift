//
//  DynamicDNSDataManager.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/18/25.
//

import Cocoa

class DynamicDNSDataManager: BaseDataManager {
    static let shared = DynamicDNSDataManager()
    weak var delegate: DynamicDNSDataManagerDelegate?

    var domainNames: [String]?

    private init() {
        super.init(source: .ddnsDataManager)
    }

    func parse(records: [RecordResponse], in domain: String) {
        var names = [String]()
        records.forEach {
            if $0.type == .A {
                names.append($0.name)
            }
        }

        // if there are no A records, but the empty domain.
        if names.isEmpty {
            names.append(domain)
        }

        domainNames = names
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

    @MainActor
    func urlCaptured(_ urlString: String) {
        delegate?.urlCaptured(urlString)
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
