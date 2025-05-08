//
//  DynamicDNSResponse.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/17/25.
//

import Foundation

/// A model representing the response returned after requesting dynamic DNS configuration.
struct DynamicDNSResponse: Codable {
    /// The unique identifier representing the bulk operation request.
    let bulkId: String

    /// The URL used to perform dynamic DNS updates.
    let updateUrl: String

    /// A list of domain names associated with the dynamic DNS configuration.
    let domains: [String]

    /// A user-provided description for the dynamic DNS request.
    let description: String
}
