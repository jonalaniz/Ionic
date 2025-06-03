//
//  Zone.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Foundation

// swiftlint:disable identifier_name
/// Represents a DNS zone.
///
/// A `Zone` typically corresponds to a domain or subdomain and is used to group DNS records
/// that belong to the same namespace. Each zone has a unique identifier, a name, and a type.
struct Zone: Codable {

    /// The unique identifier of the zone.
    ///
    /// This is assigned by IONOS and used to reference the zone in API requests.
    let id: String

    /// The name of the zone (e.g., "example.com").
    let name: String

    /// The type of the zone.
    ///
    /// This indicates how the zone behaves (e.g., native, secondary).
    let type: ZoneType
}
