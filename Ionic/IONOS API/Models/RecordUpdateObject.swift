//
//  RecordUpdateObject.swift
//  Ionic
//
//  Created by Jon Alaniz on 5/7/25.
//

import Foundation

struct RecordUpdate: Codable {
    let disabled: Bool
    let content: String
    let ttl: Int
    let prio: Int
}
