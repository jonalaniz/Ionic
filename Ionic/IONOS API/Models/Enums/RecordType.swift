//
//  RecordType.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/15/25.
//

import Foundation
// [ A, AAAA, CNAME, MX, NS, SOA, SRV, TXT, CAA, TLSA, SMIMEA, SSHFP, DS, HTTPS, SVCB, CERT, URI, RP, LOC, OPENPGPKEY ]
enum RecordType: String, Codable {
    case A = "A"
    case AAAA = "AAAA"
    case CNAME = "CNAME"
    case MX = "MX"
    case NS = "NS"
    case SOA = "SOA"
    case TXT = "TXT"
    case CAA = "CAA"
    case TLSA = "TLSA"
    case SMIMEA = "SMIMEA"
    case SSHFP = "SSHFP"
    case DS = "DS"
    case HTTPS = "HTTPS"
    case SVCB = "SVCB"
    case CERT = "CERT"
    case URI = "URI"
    case RP = "RP"
    case LOC = "LOC"
    case OPENPGPKEY = "OPENPGPKEY"

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        guard let recordType = RecordType(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid DNS record type: \(rawValue)"
            )
        }
        self = recordType
    }
}
