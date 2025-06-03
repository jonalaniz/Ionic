//
//  APIManagerError.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Foundation

enum APIManagerError: Error {

    /// The required configuration data (e.g. API key) is missing.
    case configurationMissing

    /// The `URLResponse` could not be typecast to `HTTPURLResponse`.
    case conversionFailedToHTTPURLResponse

    /// The server returned an HTTP status code outside the sucess range (200-299)
    /// and does not match an IONOS API Error.
    case invalidResponse(statuscode: Int)

    /// The provided URL was invalid or malformed.
    case invalidURL

    /// The server responded with an IONOS API Error.
    case ionosAPIError(IONOSAPIError)

    /// The response could not be decoded into the expected model.
    ///  - Parameter: `Error` is uaully a `DecodingError` from `JSONDecoder`.
    case serializationFailed(Error)

    /// A general catch-all error when the cause is unknown.
    case somethingWentWrong(error: Error?)

    /// A human-readable description for each error case.
    var errorDescription: String {
        switch self {
        case .configurationMissing:
            return "Missing configuration data"
        case .conversionFailedToHTTPURLResponse:
            return "Typecasting failed."
        case .ionosAPIError(let error):
            return error.code.message
        case .invalidResponse(let statuscode):
            return "Invalid HTTP Response Status Code (\(statuscode))"
        case .invalidURL:
            return "Invalid URL"
        case .serializationFailed(let error):
            return "Failed to decode JSON: \(error.description)"
        case .somethingWentWrong(let error):
            return error?.localizedDescription ?? "Something went wrong"
        }
    }
}
