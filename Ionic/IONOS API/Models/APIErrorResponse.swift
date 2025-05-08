//
//  APIErrorResponse.swift
//  Ionic
//
//  Created by Jon Alaniz on 5/8/25.
//

import Foundation

struct APIErrorResponse: Decodable {
    let code: String
    let message: String?
}
