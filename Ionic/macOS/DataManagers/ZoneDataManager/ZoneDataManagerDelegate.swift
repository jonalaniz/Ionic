//
//  ZoneDataManagerDelegate.swift
//  Ionic
//
//  Created by Jon Alaniz on 6/9/25.
//

import Foundation

protocol ZoneDataManagerDelegate: AnyObject {
    /// Called when zones are initially fetched and parsed successfully.
    func zonesLoaded()

    /// Called when zones have been refetched from the API.
    func zonesReloaded()

    /// Called when the user selects a zone.
    /// - Parameter zone: The `ZoneDetails` object representing the selected zone.
    func selected(_ zone: ZoneDetails)
}
