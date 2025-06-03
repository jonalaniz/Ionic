//
//  IONOSService.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Foundation

// swiftlint:disable identifier_name
class IONOSService {
    static let shared = IONOSService()
    private let apiManager = APIManager.shared
    private let keyManager = APIKeyManager.shared

    private init() {}

    func fetchZoneList() async throws -> [Zone] {
        let url = Endpoint.zones.url
        let headers = try headers()
        return try await apiManager.request(
            url: url,
            httpMethod: .get,
            body: nil,
            headers: headers)
    }

    func fetchZoneDetail(id: String) async throws -> ZoneDetails {
        let url = Endpoint.zone(id).url
        let headers = try headers()
        return try await apiManager.request(
            url: url,
            httpMethod: .get,
            body: nil,
            headers: headers)
    }

    func postDynamicDNSRecord(_ request: DynamicDNSRequest) async throws -> DynamicDNSResponse {
        let url = Endpoint.dynamicDNS.url
        let headers = try headers()
        let data = try JSONEncoder().encode(request)
        return try await apiManager.request(
            url: url,
            httpMethod: .post,
            body: data,
            headers: headers)
    }

    func update(record: RecordUpdate, zoneID: String, recordID: String) async throws -> RecordResponse {
        let url = Endpoint.record(zoneID, recordID).url
        let headers = try headers()
        let data = try JSONEncoder().encode(record)
        return try await apiManager.request(
            url: url,
            httpMethod: .put,
            body: data,
            headers: headers)
    }

    private func headers() throws -> [String: String] {
        guard let key = keyManager.key?.authenticationString else {
            throw APIManagerError.configurationMissing
        }

        return [
            "accept": "application/json",
            "X-API-Key": key,
            "Content-Type": "application/json"
        ]
    }
}
