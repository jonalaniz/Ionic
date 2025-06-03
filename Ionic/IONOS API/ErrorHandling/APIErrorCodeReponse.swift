//
//  APIErrorCodeReponse.swift
//  Ionic
//
//  Created by Jon Alaniz on 5/17/25.
//

import Foundation

struct APIErrorCodeResponse: Decodable {
    let code: String
    let message: String?
}

struct APIErrorInvalidResponse: Decodable {
    let code: String
    let message: String?
    let parameters: Parameters?

    struct Parameters: Decodable {
        let errorRecord: Record
        let inputRecord: Record?
        let invalid: [String]?
        let invalidFields: [String]?
        let requiredFields: [String]?
    }

    struct Record: Decodable {
        let name: String
        let disabled: Bool
        let rootName: String
        let content: String
        let ttl: Int
        let prio: Int
    }
}
