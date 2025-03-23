//
//  DynamicDNSResponse.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/17/25.
//

/*
 {
   "bulkId": "22af3414-abbe-9e11-5df5-66fbe8e334b4",
   "updateUrl": "https://ipv4.api.hosting.ionos.com/dns/v1/dyndns?q=",
   "domains": [
     "example-zone.de",
     "www.example-zone.de"
   ],
   "description": "My DynamicDns"
 }
 */

import Foundation

struct DynamicDNSResponse: Codable {
    let bulkId: String
    let updateUrl: String
    let domains: [String]
    let description: String
}
