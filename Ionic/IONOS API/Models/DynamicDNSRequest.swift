//
//  DynamicDNSRequest.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/17/25.
//

/*
 {
   "domains": [
     "cloud.alamoemployment.com"
   ],
   "description": "nextcloud-domain"
 }
 */

import Foundation

struct DynamicDNSRequest: Codable {
    let domains: [String]
    let description: String
}
