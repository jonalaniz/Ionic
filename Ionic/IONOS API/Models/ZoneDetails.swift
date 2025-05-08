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
    let records: [RecordResponse]
}
