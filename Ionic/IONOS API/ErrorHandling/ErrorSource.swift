//
//  ErrorSource.swift
//  Ionic
//
//  Created by Jon Alaniz on 5/25/25.
//

import Foundation

/// Represents the origin of an error within the application.
///
/// This enum is used to identify which data manager encountered an error,
/// helping in logging, debugging, and displaying appropriate user messages.
enum ErrorSource {
    /// Indicates the error originated from the zone data manager.
    case zoneDataManager

    /// Indicates the error originated from the record data manager.
    case recordDataManager

    /// Indicates the error originated from the dynamic DNS data manager.
    case ddnsDataManager
}
