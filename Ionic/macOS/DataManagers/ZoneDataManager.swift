//
//  ZoneDataManager.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/9/25.
//

import Cocoa

protocol ZoneDataManagerDelegate: AnyObject {
    /// Called when Zones were fetched and parsed successfully
    func zonesLoaded()

    func zonesReloaded()

    func selected(_ zone: ZoneDetails)
}

class ZoneDataManager: BaseDataManager {
    static let shared = ZoneDataManager()
    weak var delegate: ZoneDataManagerDelegate?

    private var zones = [Zone]()
    private var zoneDetails = [String: ZoneDetails]()

    var zonesLoaded: Bool {
        return zones.isEmpty == false
    }

    private init() {
        super.init(source: .zoneDataManager)
    }

    @MainActor func loadData() throws {
        Task {
            await loadZones()
            await loadZoneInformation()

            // Make sure the above was successful, errors will be thrown above
            guard !zones.isEmpty, !zoneDetails.isEmpty else {
                return
            }

            // Let the coordinator know we are done
            zonesDidLoad()
        }
    }

    @MainActor func reloadZones() throws {
        Task {
            await loadZoneInformation()

            guard !zoneDetails.isEmpty else {
                errorHandler?.handle(error: .conversionFailedToHTTPURLResponse, from: source)
                return
            }

            // Let the coordinator know what we have done
            zonesReloaded()
        }
    }

    func loadZones() async {
        do {
            zones = try await service.fetchZoneList()
        } catch {
            handleError(error)
        }
    }

    func loadZoneInformation() async {
        for zone in zones {
            do {
                let zoneDetail = try await service.fetchZoneDetail(id: zone.id)
                zoneDetails[zone.id] = zoneDetail
            } catch {
                handleError(error)
            }
        }
    }

    @MainActor
    private func zonesDidLoad() {
        delegate?.zonesLoaded()
    }

    @MainActor
    private func zonesReloaded() {
        delegate?.zonesReloaded()
    }

    private func select(_ zone: ZoneDetails) {
        delegate?.selected(zone)
    }
}

extension ZoneDataManager: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return zones.count
    }
}

extension ZoneDataManager: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let identifier = NSUserInterfaceItemIdentifier("ZoneCell")
        guard let cell = tableView.makeView(
            withIdentifier: identifier,
            owner: self) as? NSTableCellView
        else { return NSTableCellView() }

        cell.textField?.stringValue = zones[row].name
        cell.imageView?.image = image(for: zones[row].type)
        cell.imageView?.toolTip = zones[row].type.description

        return cell
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let tableView = notification.object as? NSTableView else { return }
        let selectedZone = zones[tableView.selectedRow]
        guard let zone = zoneDetails[selectedZone.id] else { return }
        select(zone)
    }

    private func image(for type: ZoneType) -> NSImage? {
        return NSImage(systemSymbolName: type.sfSymbolName, accessibilityDescription: "")
    }
}
