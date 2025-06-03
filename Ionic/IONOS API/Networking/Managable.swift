//
//  Managable.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Foundation

protocol Managable {
    func request<T: Codable>(url: URL,
                             httpMethod: ServiceMethod,
                             body: Data?,
                             headers: [String: String]?
    ) async throws -> T
}
