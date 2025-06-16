//
//  HeaderKeyValue.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Foundation

/// A representation of common HTTP header keys and values used in API requests.
enum HeaderKeyValue: String {

    /// The `Accept` header key, used to specify acceptable media types for the response.
    case accept = "Accept"

    /// The `X-API-Key` header key, used to authenticate with the API.
    case xAPIKey = "X-API-Key"

    /// The `application/json` header value, used to indicate JSON content type.
    case applicationJSON = "application/json"
}
