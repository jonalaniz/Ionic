//
//  API Manager.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Foundation

final class APIManager: Managable {
    public internal(set) var session = URLSession.shared

    static let shared: Managable = APIManager()

    private init() {}

    /// Performs a request and returns void. Useful for DELETE method
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
        return try await self.handleResponse(data: data, response: response)
    }

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

    private func decode<T: Decodable>(_ data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }

    private func handleResponse<T: Decodable>(data: Data, response: URLResponse) async throws -> T {
        try validateResponse(data: data, response: response)

        do {
            return try decode(data)
        } catch {
            throw APIManagerError.serializationFailed(error)
        }
    }

    private func validateResponse(data: Data, response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIManagerError.conversionFailedToHTTPURLResponse
        }

        let statusCode = httpResponse.statusCode
        print(statusCode)

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
}
