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

enum Key: String {
    case service = "com.jonalaniz.ionic"
    case account = "apiKeys"
}

class APIKeyManager {
    static let shared = APIKeyManager()
    private let keychainHelper = KeychainHelper(service: Key.service.rawValue)
    private let account = Key.account.rawValue
    private(set) var key: DNSAPIKey?

    private init() {
        loadKey()
    }

    func addKey(_ key: DNSAPIKey) {
        self.key = key
        save()
    }

    private func loadKey() {
        do {
            let key = try keychainHelper.get(DNSAPIKey.self, for: account)
            self.key = key
            print(key)
        } catch let error as KeychainError {
            handleKeychainError(error)
        } catch let error as DecodingError {
            handleDecodingError(error)
        } catch {
            print(error.localizedDescription)
        }
    }

    private func save() {
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
