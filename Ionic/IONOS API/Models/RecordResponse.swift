//
//  RecordResponse.swift
//  Ionic
//
//  Created by Jon Alaniz on 5/7/25.
//

import Foundation

// swiftlint:disable identifier_name
/// A model representing a DNS record returned from the API.
///
/// This structure includes all necessary metadata for identifying and rendering a
/// DNS record in the UI or for further editing.
struct RecordResponse: Codable {

    /// The unique identifier for the DNS record.
    let id: String

    /// The full name (FQDN) of the record, e.g., `www.example.com`.
    let name: String

    /// The root zone name this record belongs to, e.g., `example.com`.
    let rootName: String

    /// The DNS record type (e.g., A, AAAA, MX, CNAME).
    let type: RecordType

    /// The value associated with the record (e.g., IP address, canonical name).
    let content: String

    /// The last modification date of the record.
    ///
    /// Formatted as `yyyy-MM-dd'T'HH:mm:ss.SSS'Z'`.
    let changeDate: String

    /// The time-to-live (TTL) value in seconds for this record.
    let ttl: Int

    /// The priority value for records like MX or SRV.
    ///
    /// Optional because not all record types require a priority.
    let prio: Int?

    /// A Boolean flag indicating whether the record is disabled.
    let disabled: Bool
}
