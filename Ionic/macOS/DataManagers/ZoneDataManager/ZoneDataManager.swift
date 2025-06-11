//
//  ZoneDataManager.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/9/25.
//

import Cocoa

class ZoneDataManager: BaseDataManager {
    // MARK: - Singleton

    static let shared = ZoneDataManager()
    private init() { super.init(source: .zoneDataManager) }

    // MARK: - Properties

    weak var delegate: ZoneDataManagerDelegate?

    private var zones = [Zone]()
    private var zoneDetails = [String: ZoneDetails]()

    var selectedZone: String?
    var zonesLoaded: Bool {
        return zones.isEmpty == false
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

    func update(zone zoneDetail: ZoneDetails) {
        zoneDetails[zoneDetail.id] = zoneDetail
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
        selectedZone = zone.name
        delegate?.selected(zone)
    }
}

// MARK: - NSTableViewDataSource & Delegate

extension ZoneDataManager: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return zones.count
    }

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
