//
//  ErrorHandling.swift
//  Ionic
//
//  Created by Jon Alaniz on 5/25/25.
//

import Foundation

/// A protocol that defines a standardized interface for handling errors produced by the API manager.
protocol ErrorHandling: NSObject {

    /// Handles the given API error originating from a specific source.
    ///
    /// - Parameters:
    ///   - error: The `APIManagerError` encountered.
    ///   - source: The `ErrorSource` where the error originated.
    func handle(error: APIManagerError, from source: ErrorSource)
}
