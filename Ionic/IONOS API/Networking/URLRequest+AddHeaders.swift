//
//  URLRequest+AddHeaders.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Foundation

extension URLRequest {
    mutating func addHeaders(from headers: [String: String]?) {
        self.addDefaultHeaders()

        if let headers = headers {
            headers.forEach { self.addValue($0.value, forHTTPHeaderField: $0.key) }
        }
    }

    mutating func addDefaultHeaders() {
        self.addValue(
            HeaderKeyValue.applicationJSON.rawValue,
            forHTTPHeaderField: HeaderKeyValue.accept.rawValue
        )
    }
}
