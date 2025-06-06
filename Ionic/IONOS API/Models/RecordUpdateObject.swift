//
//  RecordUpdateObject.swift
//  Ionic
//
//  Created by Jon Alaniz on 5/7/25.
//

import Foundation

/// A data transfer object used to update an existing DNS record on the server via a PUT request.
///
/// `RecordUpdate` encapsulates the modifiable attributes of a DNS record such as its enabled/disabled status,
/// content value, TTL (time to live), and priority. This struct is typically encoded as JSON in API calls
/// to update a specific DNS record.
struct RecordUpdate: Codable {
    let disabled: Bool
    let content: String
    let ttl: Int
    let prio: Int
}
