//
//  Notification+SelectedRecordDidChange.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/21/25.
//

import Foundation

extension Notification.Name {
    static let selectedRecordUpdated = Notification.Name("selectedRecordUpdated")
    static let selectedRecordDidChange = Notification.Name("selectedRecordDidChange")
    static let selectedZoneDidChange = Notification.Name("selectedZoneDidChange")
    static let zonesDidChange = Notification.Name("zonesDidChange")
    static let zonesDidReload = Notification.Name("zonesDidReload")
}
