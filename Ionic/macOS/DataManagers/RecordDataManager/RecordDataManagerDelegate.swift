//
//  DNSRecordDataManagerDelegate.swift
//  Ionic
//
//  Created by Jon Alaniz on 6/5/25.
//

import Foundation

enum RecordDataManagerState {
    case zoneSelected
    case recordCreated
    case recordDeleted
    case recordSelected
    case recordUpdated
}

protocol RecordDataManagerDelegate: AnyObject {
    func stateDidChange(_ state: RecordDataManagerState)

    func updateZoneDetail(_ zone: ZoneDetails)
}
