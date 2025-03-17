//
//  DNSRecordRequest.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/15/25.
//

/*
 [
    {
     "name": "test.alamoemployment.com",
     "type": "A",
     "content": "1.2.3.4",
     "ttl": 3600,
     "prio": 0,
     "disabled": true
    }
 [
 */

import Foundation

struct DNSRecordRequest {
    let name: String
    let type: String
    let content: String
    let ttl: Int
    let prio: Int
    let disabled: Bool
}
