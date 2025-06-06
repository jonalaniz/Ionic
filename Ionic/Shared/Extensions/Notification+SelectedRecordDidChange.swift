//
//  Notification+SelectedRecordDidChange.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/21/25.
//

import Foundation

extension Notification.Name {
    static let recordCreated = Notification.Name("recordCreated")
    static let selectedRecordUpdated = Notification.Name("selectedRecordUpdated")
    static let selectedRecordDidChange = Notification.Name("selectedRecordDidChange")
    static let selectedRecordWasDeleted = Notification.Name("selectedRecordWasDeleted")
    static let selectedZoneDidChange = Notification.Name("selectedZoneDidChange")
    static let zonesDidChange = Notification.Name("zonesDidChange")
    static let zonesReloading = Notification.Name("zonesReloading")
    static let zonesDidReload = Notification.Name("zonesDidReload")
}
