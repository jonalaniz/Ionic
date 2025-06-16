//
//  DynamicDNSRequest.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/17/25.
//

import Foundation

/// A structure representing a request to create a Dynamic DNS update URL.
struct DynamicDNSRequest: Codable {
    /// An array of domain names for which the Dynamic DNS update URL should be created.
    let domains: [String]

    /// Description for the request.
    /// The API accepts this field, though its purpose is unclear—it may be used for labeling or identifying the generated URL.
    let description: String
}
