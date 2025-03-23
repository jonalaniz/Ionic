//
//  Endpoint.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Foundation

enum Endpoint {
    private var baseURL: String { return "https://api.hosting.ionos.com/dns/v1" }

    case dynamicDNS
    case zones
    case zone(String)

    var url: URL {
        guard var url = URL(string: baseURL) else {
            preconditionFailure("The url used in \(Endpoint.self) is not valid.")
        }

        switch self {
        case .dynamicDNS: url.appendPathComponent("dyndns")
        case .zones: url.appendPathComponent("zones")
        case .zone(let id): url.appendPathComponent("zones/\(id)")
        }

        return url
    }
}
