//
//  ZoneDetails.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Foundation

/*
 {
   "id": "11af3414-ebba-11e9-8df5-66fbe8a334b4",
   "name": "example-zone.de",
   "type": "NATIVE",
   "records": [
     {
       "id": "22af3414-abbe-9e11-5df5-66fbe8e334b4",
       "name": "example-zone.de",
       "rootName": "example-zone.de",
       "type": "A",
       "content": "1.1.1.1",
       "changeDate": "2019-12-09T13:04:25.772Z",
       "ttl": 3600,
       "prio": 0,
       "disabled": false
     }
   ]
 }
 */

struct ZoneDetails: Codable {
    let id: String
    let name: String
    let type: String
    let records: [DNSRecord]
}

struct DNSRecord: Codable {
    let id: String
    let name: String
    let rootName: String
    let type: String
    let content: String
    let changeDate: String
    let ttl: Int
    let prio: Int?
    let disabled: Bool
}
