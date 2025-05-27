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
    weak var errorHandler: ErrorHandling?
    
    private let service = IONOSService.shared
    var domainNames: [String]?
    
    private override init() {}

    func parse(records: [RecordResponse]) {
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
    
    private func handleError(_ error: Error) {
        guard let apiError = error as? APIManagerError else {
            errorHandler?.handle(
                error: APIManagerError.somethingWentWrong(error: error),
                from: .ddnsDataManager
            )
            return
        }
                
        errorHandler?.handle(error: apiError, from: .ddnsDataManager)
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
