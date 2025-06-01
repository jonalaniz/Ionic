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
/// The supported record types are those explicly shown as capable wth the API, experimental will be tested at a later date.
/// - Supported types: A, AAAA, CNAME, MX, NS, SOA, TXT, CAA
/// - Experimental types: TLSA, SMIMEA, SSHFP, DS, HTTPS, SVCB, CERT,
///   URI, RP, LOC, OPENPGPKEY
enum RecordType: String, CaseIterable, Codable {
    case A = "A"
    case AAAA = "AAAA"
    case CNAME = "CNAME"
    case MX = "MX"
    case NS = "NS"
    case SOA = "SOA"
    case SRV = "SRV"
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
    
    /// Display-friendly name for the record type.
    var name: String {
        switch self {
        case .CNAME, .SMIMEA, .SSHFP, .HTTPS, .OPENPGPKEY: return self.rawValue
        default: return "\(self.rawValue) Record"
        }
    }
    
    /// A short human-readable description of the record type’s purpose.
    var description: String {
        switch self {
        case .A: return "Maps a domain name or subdomain to an IPv4 address."
        case .AAAA: return "Maps a domain name or subdomain to an IPv6 address."
        case .CNAME: return "Map one domain to another (alias to canonical name)."
        case .MX: return "Specifies the mail server for your domain."
        case .NS: return "Specifices the name server for your domain."
        case .SRV: return "Specifies the location of a service for your domain."
        case .TXT: return "Stores text data for your domain, can be used for verification or security."
        default: return ""
        }
    }

    /// Custom decoding to validate raw string values during decoding.
    ///
    /// Throws an error if the string does not correspond to a known DNS record type.
    /// This ensures data integrity when decoding from JSON or other external data.
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
    
    /// Indicates whether this record type is considered experimental.
    ///
    /// Experimental record types are not currently supported by Ionic DNS.
    func experimental() -> Bool {
        switch self {
        case .A, .AAAA, .CNAME, .MX, .NS, .SRV, .TXT: return false
        default: return true
        }
    }
    
    /// Indicates whether this record type requires a priority field.
    func requiresPriority() -> Bool {
        switch self {
        case .MX, .SRV: return true
        default: return false
        }
    }
}
