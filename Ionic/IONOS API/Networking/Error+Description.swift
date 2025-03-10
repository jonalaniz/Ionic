//
//  Error+Description.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Foundation

extension Error {
    var description: String {
        ((self as? APIManagerError)?.errorDescription) ?? self.localizedDescription
    }
}
