//
//  APIKeyManager.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/23/25.
//

import Foundation

class APIKeyManager {
    static let shared = APIKeyManager()

    private var publicKey: String?
    private var privateKey: String?

    var key: String? {
        guard let publicKey = publicKey, let privateKey = privateKey
        else { return nil }
        return publicKey + "." + privateKey
    }

    private init() {}

    func set(publicKey: String, privateKey: String) {
        self.publicKey = publicKey
        self.privateKey = privateKey
    }
}
