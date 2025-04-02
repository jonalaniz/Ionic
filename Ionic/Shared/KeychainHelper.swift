//
//  KeychainHelper.swift
//  Ionic
//
//  Created by Jon Alaniz on 4/1/25.
//

import Foundation
import Security

enum KeychainError: Error {
    /// Item does not exist in Keychain.
    case itemNotFound

    /// Attempted to save an existing item. Use update instead.
    case duplicateItem

    /// The retrieved item is in a format other than `Data`.
    case invalidItemFormat

    /// An unexpected OSStatus error occurred.
    case unexpectedStatus(OSStatus)
}

/**
 A helper class for securely storing and retrieving data from the iOS/macOS Keychain.

 ## Keychain Attributes Used:
 - `kSecAttrService`: A string to identify a set of Keychain items (e.g., "com.jonalaniz.ionic").
 - `kSecAttrAccount`: A string to identify a specific Keychain item within a service (e.g., "jon@alaniz.tech").
 - `kSecClass`: The type of secure data stored in the Keychain, such as `kSecClassGenericPassword`.
 - `kSecMatchLimitOne`: Ensures only one matching item is returned when retrieving data.
 - `kSecReturnData`: Specifies that the retrieved item should be returned as `Data`.
 */
class KeychainHelper {

    /// Stores data in the Keychain.
    /// - Parameters:
    ///   - data: The data to store securely.
    ///   - service: The Keychain service identifier.
    ///   - account: The account identifier for the stored data.
    /// - Throws: `KeychainError.duplicateItem` if the item already exists, or `KeychainError.unexpectedStatus` if an error occurs.
    /// - Returns: `true` if the data was successfully stored.
    static func  storeData(data: Data, forService service: String, account: String) throws -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        if status == errSecDuplicateItem  {
            throw KeychainError.duplicateItem
        }

        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }

        return status == errSecSuccess
    }

    /// Retrieves data from the Keychain.
    /// - Parameters:
    ///   - service: The Keychain service identifier.
    ///   - account: The account identifier for the stored data.
    /// - Throws: `KeychainError.itemNotFound` if no matching item is found,
    ///           `KeychainError.invalidItemFormat` if the stored data is not `Data`.
    /// - Returns: The retrieved data.
    static func retrieveData(forService service: String, account: String) throws -> Data {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue
        ]

        var itemCopy: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &itemCopy)

        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }

        guard let data = itemCopy as? Data else {
            throw KeychainError.invalidItemFormat
        }

        return data
    }
}
