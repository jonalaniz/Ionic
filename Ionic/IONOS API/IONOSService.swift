//
//  IONOSService.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Foundation

class IONOSService {
    static let shared = IONOSService()
    private let apiManager = APIManager.shared

    private init() {}

    func fetchZoneList(with apiKey: String) async throws -> [Zone] {
        let url = Endpoint.zones.url
        let headers = headers(key: apiKey)

        return try await apiManager.request(
            url: url,
            httpMethod: .get,
            body: nil,
            headers: headers,
            expectingReturnType: [Zone].self)
    }

    func fetchZoneDetail(id: String, with apiKey: String) async throws -> ZoneDetails {
        let url = Endpoint.zone(id).url
        let headers = headers(key: apiKey)
        return try await apiManager.request(
            url: url,
            httpMethod: .get,
            body: nil,
            headers: headers,
            expectingReturnType: ZoneDetails.self)
    }

    private func headers(key: String) -> [String: String] {
        return ["accept": "application/json", "X-API-Key": key]
    }
}
