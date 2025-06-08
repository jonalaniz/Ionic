//
//  DNSRecordDataManagerDelegate.swift
//  Ionic
//
//  Created by Jon Alaniz on 6/5/25.
//

import Foundation

enum DNSRecordDataManagerState {
    case zoneSelected
    case recordCreated
    case recordDeleted
    case recordSelected
    case recordUpdated
}

protocol DNSRecordDataManagerDelegate: AnyObject {
    func stateDidChange(_ state: DNSRecordDataManagerState)

    func updateZoneDetail(_ zone: ZoneDetails)
}
