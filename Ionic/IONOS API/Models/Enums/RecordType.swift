//
//  RecordType.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/15/25.
//

import Foundation

/// An enumeration of supported DNS record types.
///
/// This enum represents common and advanced DNS record types used in zone configurations,
/// and conforms to `Codable` for easy encoding and decoding.
///
/// Supported record types include:
/// - A, AAAA, CNAME, MX, NS, SOA, TXT, CAA
/// - TLSA, SMIMEA, SSHFP, DS, HTTPS, SVCB, CERT
/// - URI, RP, LOC, OPENPGPKEY
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
        let string = try container.decode(String.self)
        guard let recordType = RecordType(rawValue: string) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid DNS record type: \(string)")
        }
        
        self = recordType
    }
}
