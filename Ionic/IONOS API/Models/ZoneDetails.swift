//
//  ZoneDetails.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Foundation

// swiftlint:disable identifier_name
/// Represents detailed information about a DNS zone, including its associated records.
///
/// `ZoneDetails` includes basic zone metadata along with a collection of DNS records
/// that are associated with the zone.
struct ZoneDetails: Codable {

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

    /// A list of DNS records associated with the zone.
    ///
    /// Each record contains detailed information such as name, content, TTL, and type (e.g., A, MX, CNAME).
    let records: [RecordResponse]
}
