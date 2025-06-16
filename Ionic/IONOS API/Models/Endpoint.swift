//
//  Endpoint.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Foundation

// swiftlint:disable identifier_name
/// An enumeration representing the available API endpoints for the IONOS DNS service.
enum Endpoint {
    /// The base URL for all IONOS DNS API requests.
    private var baseURL: String { return "https://api.hosting.ionos.com/dns/v1" }

    /// Endpoint for creating or fetching Dynamic DNS update URLs.
    case dynamicDNS

    /// Endpoint for retrieving all DNS zones.
    case zones

    /// Endpoint for retrieving a specific zone by its identifier.
    ///
    /// - Parameter id: The identifier of the zone.
    case zone(String)

    /// Endpoint for creating a new record in a specific zone.
    ///
    /// - Parameter id: The identifier of the zone where the record will be added.
    case newRecord(String)

    /// Endpoint for retrieving or modifying a specific DNS record in a specific zone.
    ///
    /// - Parameters:
    ///   - zoneID: The identifier of the zone.
    ///   - recordID: The identifier of the DNS record.
    case record(String, String)

    /// Computes the full `URL` for the endpoint, based on its associated values.
    ///
    /// - Returns: A fully constructed `URL` for the endpoint.
    var url: URL {
        guard var url = URL(string: baseURL) else {
            preconditionFailure("The url used in \(Endpoint.self) is not valid.")
        }

        switch self {
        case .dynamicDNS: url.appendPathComponent("dyndns")
        case .zones: url.appendPathComponent("zones")
        case .zone(let id): url.appendPathComponent("zones/\(id)")
        case .newRecord(let id): url.appendPathComponent("zones/\(id)/records")
        case .record(let zoneID, let recordID):
            url.appendPathComponent("zones/\(zoneID)/records/\(recordID)")
        }

        return url
    }
}
