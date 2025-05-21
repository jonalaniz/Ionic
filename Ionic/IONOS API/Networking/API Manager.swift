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

    func request<T>(url: URL,
                    httpMethod: ServiceMethod,
                    body: Data?,
                    headers: [String : String]?
    ) async throws -> T where T: Decodable {
        let request = buildRequest(url: url,
                                   httpMethod: httpMethod,
                                   body: body,
                                   headers: headers)

        return try await self.handleResponse(session.data(for: request))
    }

    private func handleResponse<T: Decodable>(_ dataWithResponse: (data: Data, response: URLResponse)
    ) async throws -> T {
        guard let response = dataWithResponse.response as? HTTPURLResponse else {
            throw APIManagerError.conversionFailedToHTTPURLResponse
        }
        
        // Here we grab the status code and data
        let statusCode = response.statusCode
        let data = dataWithResponse.data
        
        // Check for error status codes
        guard (200...299).contains(statusCode) else {
            // Decode as an IONOS API Error first
            if let errorCode = IONOSAPIErrorCode(rawValue: statusCode) {
                let error = IONOSAPIError(code: errorCode, responseData: data)
                throw APIManagerError.ionosAPIError(error)
            } else {
                throw APIManagerError.invalidResponse(statuscode: statusCode)
            }
        }

        do {
            return try decode(data)
        } catch {
            throw APIManagerError.serializaitonFailed(error)
        }
    }
    
    private func decode<T: Decodable>(_ data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
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
}
