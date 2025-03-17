//
//  ZoneType.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/15/25.
//

import Foundation

enum ZoneType: String, Codable {
    case native = "NATIVE"
    case slave = "SLAVE"

    var sfSymbolName: String {
        switch self {
        case .native: return "n.square"
        case .slave: return "s.square"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)

        guard let zoneType = ZoneType(rawValue: string) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid Zone type: \(string)")
        }

        self = zoneType
    }
}
