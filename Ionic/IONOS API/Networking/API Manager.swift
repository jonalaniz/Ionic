//
//  API Manager.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Foundation

final class APIManager: Managable {
    // MARK: - Singleton

    static let shared: Managable = APIManager()
    private init() {}

    // MARK: - Properties
    public internal(set) var session = URLSession.shared

    // MARK: - URL Requests

    /// Performs a network request that does not return a decoded response.
    ///
    /// Use this method for HTTP requests like `DELETE` that do not return data to be decoded.
    ///
    /// - Parameters:
    ///   - url: The endpoint URL.
    ///   - httpMethod: The HTTP method to use (e.g., `.get`, `.post`, `.delete`).
    ///   - body: The HTTP request body as `Data`, if any.
    ///   - headers: Optional headers to include in the request.
    /// - Throws: An `APIManagerError` if the response is invalid or another error occurs.
    func request(url: URL,
                 httpMethod: ServiceMethod,
                 body: Data?,
                 headers: [String: String]?
    ) async throws {
        let request = buildRequest(
            url: url,
            httpMethod: httpMethod,
            body: body,
            headers: headers
        )
        let (data, response) = try await session.data(for: request)
        try validateResponse(data: data, response: response)

    }

    /// Performs a network request and decodes the response into the specified `Decodable` type.
    ///
    /// - Parameters:
    ///   - url: The endpoint URL.
    ///   - httpMethod: The HTTP method to use.
    ///   - body: The HTTP request body as `Data`, if any.
    ///   - headers: Optional headers to include in the request.
    /// - Returns: A decoded object of type `T` that conforms to `Decodable`.
    /// - Throws: An `APIManagerError` or decoding error if the request or decoding fails.
    func request<T>(url: URL,
                    httpMethod: ServiceMethod,
                    body: Data?,
                    headers: [String: String]?
    ) async throws -> T where T: Decodable {
        let request = buildRequest(
            url: url,
            httpMethod: httpMethod,
            body: body,
            headers: headers
        )
        let (data, response) = try await session.data(for: request)
        return try await handleResponse(data: data, response: response)
    }

    // MARK: - Helper Methods

    /// Constructs a `URLRequest` using the specified parameters.
    ///
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - httpMethod: The HTTP method to use.
    ///   - body: Optional HTTP body data.
    ///   - headers: Optional HTTP headers.
    /// - Returns: A configured `URLRequest` instance.
    private func buildRequest(url: URL,
                              httpMethod: ServiceMethod,
                              body: Data?,
                              headers: [String: String]?
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue

        if let body = body, httpMethod != .get {
            request.httpBody = body
        }

        request.addHeaders(from: headers)

        return request
    }

    /// Validates the HTTP response and throws errors for non-success status codes.
    ///
    /// - Parameters:
    ///   - data: The raw response data.
    ///   - response: The URL response object.
    /// - Throws: An `APIManagerError` if response is not `HTTPURLResponse`, or the status code is not in the 2xx range.
    private func validateResponse(data: Data, response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIManagerError.conversionFailedToHTTPURLResponse
        }

        let statusCode = httpResponse.statusCode
        guard (200...299).contains(statusCode) else {
            // Decode as an IONOS API Error first
            if let errorCode = IONOSAPIErrorCode(rawValue: statusCode) {
                throw APIManagerError.ionosAPIError(
                    IONOSAPIError(code: errorCode, responseData: data)
                )
            } else {
                throw APIManagerError.invalidResponse(statuscode: statusCode)
            }
        }
    }

    /// Validates and decodes a successful response.
    ///
    /// - Parameters:
    ///   - data: The raw data returned by the request.
    ///   - response: The response object returned by the request.
    /// - Returns: A decoded object of type `T` conforming to `Decodable`.
    /// - Throws: An `APIManagerError` if validation or decoding fails.
    private func handleResponse<T: Decodable>(data: Data, response: URLResponse) async throws -> T {
        try validateResponse(data: data, response: response)

        do {
            return try decode(data)
        } catch {
            throw APIManagerError.serializationFailed(error)
        }
    }

    /// Decodes raw data into a specified `Decodable` type.
    ///
    /// - Parameter data: The data to decode.
    /// - Returns: A decoded instance of type `T`.
    /// - Throws: A decoding error if the data cannot be decoded.
    private func decode<T: Decodable>(_ data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}
