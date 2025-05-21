//
//  APIManagerError.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Foundation

enum APIManagerError: Error {
    case configurationMissing
    case conversionFailedToHTTPURLResponse
    case invalidResponse(statuscode: Int)
    case invalidURL
    case ionosAPIError(IONOSAPIError)
    case serializaitonFailed(Error)
    case somethingWentWrong(error: Error?)

    var errorDescription: String {
        switch self {
        case .configurationMissing:
            return "Missing configuration data"
        case .conversionFailedToHTTPURLResponse:
            return "Typecasting failed."
        case .ionosAPIError(let error):
            return error.code.message
        case .invalidResponse(let statuscode):
            return "Invalid Response (\(statuscode))"
        case .invalidURL:
            return "Invalid URL"
        case .serializaitonFailed(let error):
            return "Failed to decode JSON: \(error.description)"
        case .somethingWentWrong(let error):
            return error?.localizedDescription ?? "Something went wrong"
        }
    }
}
