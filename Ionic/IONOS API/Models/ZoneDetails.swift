//
//  ZoneDetails.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Foundation

struct ZoneDetails: Codable {
    let id: String
    let name: String
    let type: ZoneType
    let records: [DNSRecordResponse]
}

struct DNSRecordResponse: Codable {
    let id: String
    let name: String
    let rootName: String
    let type: RecordType
    let content: String
    let changeDate: String
    let ttl: Int
    let prio: Int?
    let disabled: Bool
}
