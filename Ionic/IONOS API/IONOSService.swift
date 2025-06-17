//
//  IONOSService.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Foundation

// swiftlint:disable identifier_name
/// A service layer responsible for interacting with the IONOS DNS API.
/// Provides methods to fetch zones, manage DNS records, and generate dynamic DNS URLs.
class IONOSService {

    // MARK: - Singleton

    /// Shared singleton instance of the service.
    static let shared = IONOSService()

    /// Private initializer to enforce singleton usage.
    private init() {}

    // MARK: - Dependencies

    /// Shared instance of the API manager used for network requests.
    private let apiManager = APIManager.shared

    /// Shared instance of the API key manager used to retrieve the API key.
    private let keyManager = APIKeyManager.shared

    // MARK: - Network Requests

    /// Creates a new DNS record in the specified zone.
    ///
    /// - Parameters:
    ///   - record: The DNS `Record` to create.
    ///   - zone: The ID of the DNS zone.
    /// - Returns: An array of `RecordResponse` objects representing the created records.
    func create(record: Record, in zone: String) async throws -> [RecordResponse] {
        let url = Endpoint.newRecord(zone).url
        let headers = try headers()
        let data = try JSONEncoder().encode([record])
        return try await apiManager.request(
            url: url,
            httpMethod: .post,
            body: data,
            headers: headers
        )
    }

    /// Deletes a DNS record from the specified zone.
    ///
    /// - Parameters:
    ///   - record: The ID of the record to delete.
    ///   - zone: The ID of the DNS zone.
    func delete(record: String, in zone: String) async throws {
        let url = Endpoint.record(zone, record).url
        let headers = try headers()
        try await apiManager.request(
            url: url,
            httpMethod: .delete,
            body: nil,
            headers: headers
        )
    }

    /// Fetches the list of all available DNS zones.
    ///
    /// - Returns: An array of `Zone` objects.
    func fetchZoneList() async throws -> [Zone] {
        let url = Endpoint.zones.url
        let headers = try headers()
        return try await apiManager.request(
            url: url,
            httpMethod: .get,
            body: nil,
            headers: headers
        )
    }

    /// Fetches detailed information about a specific DNS zone.
    ///
    /// - Parameter id: The ID of the zone to fetch.
    /// - Returns: A `ZoneDetails` object containing details about the zone.
    func fetchZoneDetail(id: String) async throws -> ZoneDetails {
        let url = Endpoint.zone(id).url
        let headers = try headers()
        return try await apiManager.request(
            url: url,
            httpMethod: .get,
            body: nil,
            headers: headers
        )
    }

    /// Sends a request to create a dynamic DNS update URL for the specified domains.
    ///
    /// - Parameter request: A `DynamicDNSRequest` containing the domains and optional description.
    /// - Returns: A `DynamicDNSResponse` object containing the generated update URL.
    func postDynamicDNSRecord(_ request: DynamicDNSRequest) async throws -> DynamicDNSResponse {
        let url = Endpoint.dynamicDNS.url
        let headers = try headers()
        let data = try JSONEncoder().encode(request)
        return try await apiManager.request(
            url: url,
            httpMethod: .post,
            body: data,
            headers: headers
        )
    }

    /// Updates an existing DNS record in the specified zone.
    ///
    /// - Parameters:
    ///   - record: A `RecordUpdate` containing updated DNS record data.
    ///   - zoneID: The ID of the zone containing the record.
    ///   - recordID: The ID of the record to update.
    /// - Returns: A `RecordResponse` containing the updated record information.
    func update(record: RecordUpdate, zoneID: String, recordID: String) async throws -> RecordResponse {
        let url = Endpoint.record(zoneID, recordID).url
        let headers = try headers()
        let data = try JSONEncoder().encode(record)
        return try await apiManager.request(
            url: url,
            httpMethod: .put,
            body: data,
            headers: headers
        )
    }

    // MARK: - Helper Methods


    /// Constructs the request headers for authorized API access.
    ///
    /// - Throws: `APIManagerError.configurationMissing` if the API key is not available.
    /// - Returns: A dictionary of HTTP headers including the API key.
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
