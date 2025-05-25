//
//  ErrorHandling.swift
//  Ionic
//
//  Created by Jon Alaniz on 5/25/25.
//

import Foundation

protocol ErrorHandling: NSObject {
    func handle(error: APIManagerError, from source: ErrorSource)
}
