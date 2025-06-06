//
//  Record.swift
//  Ionic
//
//  Created by Jon Alaniz on 5/7/25.
//

import Foundation

/// A data transfer object used to create a new DNS record via a POST request.
///
/// The `Record` struct represents all the necessary fields required when submitting
/// a new DNS record to the server. This is typically used in API calls to add entries such as A, CNAME, or MX records.
struct Record: Codable {
    let name: String
    let type: RecordType
    let content: String
    let ttl: Int
    let prio: Int?
    let disabled: Bool
}
