//
//  APIErrorCode.swift
//  Ionic
//
//  Created by Jon Alaniz on 5/17/25.
//

import Foundation

struct IONOSAPIError: Error {
    let code: IONOSAPIErrorCode
    let responseData: Data?
}

/// Represents known HTTP status codes returned by the API and their associated meanings.
///
/// - `400` - Returns a `RecordError` based on detailed record validation failure.
/// - `401`, `403`, `404` - Returns an `APIError` with a provided message from the server.
/// - `429` - Indicates rate limiting; does not result in a thrown API error.
/// - `500` - Indicates a server-side error; returns an `APIError` with no message.
enum IONOSAPIErrorCode: Int {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case recordNotFound = 404
    case rateLimitExceeded = 429
    case internalServerError = 500

    var message: String {
        switch self {
        case .badRequest: return "Bad Request"
        case .unauthorized: return "Unauthorized"
        case .forbidden: return "Forbidden"
        case .recordNotFound: return "Record Not Found"
        case .rateLimitExceeded: return "Rate Limit Exceeded"
        case .internalServerError: return "Internal Server Error"
        }
    }
}
