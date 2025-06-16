//
//  APIKeyManager.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/23/25.
//

import Foundation

struct DNSAPIKey: Codable {
    let name: String
    let publicKey: String
    let privateKey: String

    var authenticationString: String {
        return publicKey + "." + privateKey
    }
}

class APIKeyManager {
    // MARK: - Singleton

    /// Shared singleton instance of the service.
    static let shared = APIKeyManager()

    /// Private initializer to enforce singleton usage.
    private init() { loadKey() }

    // MARK: - Properties

    private let keychainHelper = KeychainHelper(service: "com.jonalaniz.ionic")
    private let account = "apiKeys"
    private(set) var key: DNSAPIKey?

    // MARK: - Keychain Methods

    func addKey(_ key: DNSAPIKey, save: Bool) {
        self.key = key
        if save { saveKey() }
    }

    private func loadKey() {
        do {
            let key = try keychainHelper.get(DNSAPIKey.self, for: account)
            self.key = key
        } catch let error as KeychainError {
            handleKeychainError(error)
        } catch let error as DecodingError {
            handleDecodingError(error)
        } catch {
            print(error.localizedDescription)
        }
    }

    private func saveKey() {
        do {
            try keychainHelper.set(key, for: account)
        } catch let error as KeychainError {
            handleKeychainError(error)
        } catch let error as EncodingError {
            handleEncodingError(error)
        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: - Error Handling

    private func handleKeychainError(_ error: KeychainError) {
        switch error {
        case .itemNotFound: print("Item not found")
        case .duplicateItem: print("Duplicate item")
        case .invalidItemFormat: print("Invalid item format")
        case .unexpectedStatus(let oSStatus): print(oSStatus.description)
        }
    }

    private func handleEncodingError(_ error: EncodingError) {
        print(error.localizedDescription)
    }

    private func handleDecodingError(_ error: DecodingError) {
        print(error.localizedDescription)
    }
}
