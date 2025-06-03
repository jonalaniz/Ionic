//
//  RecordFactory.swift
//  Ionic
//
//  Created by Jon Alaniz on 6/2/25.
//

import Foundation

class RecordFactory: NSObject {
    static let shared = RecordFactory()

    var domain: String?

    private override init() {}
}
