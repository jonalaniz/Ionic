//
//  HTTPURLResponse+StatusCodeChecker.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Foundation

extension HTTPURLResponse {
    func statusCodeChecker() throws {
        switch self.statusCode {
        case 200...299: return
        default:
            throw APIManagerError.invalidResponse(statuscode: self.statusCode)
        }
    }
}
