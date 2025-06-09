//
//  DNSRecordDataManagerDelegate.swift
//  Ionic
//
//  Created by Jon Alaniz on 6/5/25.
//

import Foundation

enum RecordDataManagerState {
    /// A DNS zone has been selected.
    case zoneSelected

    /// A DNS record has been successfully created.
    case recordCreated

    /// A DNS record has been successfully deleted.
    case recordDeleted

    /// A DNS record has been selected (e.g., via a table view).
    case recordSelected

    /// A DNS record has been updated (e.g., content, TTL, or status change).
    case recordUpdated
}

protocol RecordDataManagerDelegate: AnyObject {
    /// Called when a significant state change occurs in the record data manager.
    /// - Parameter state: The new state that describes what action was performed.
    func stateDidChange(_ state: RecordDataManagerState)

    /// Called when the details of the selected zone have changed, typically after records are updated.
    /// - Parameter zone: The updated `ZoneDetails` object reflecting the current state of the zone.
    func updateZoneDetail(_ zone: ZoneDetails)
}
