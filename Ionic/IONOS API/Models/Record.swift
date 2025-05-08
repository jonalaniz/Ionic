//
//  Record.swift
//  Ionic
//
//  Created by Jon Alaniz on 5/7/25.
//

import Foundation

struct Record: Codable {
    let name: String
    let type: RecordType
    let content: String
    let ttl: Int
    let prio: Int?
    let disabled: Bool
}
