//
//  DNSRecordDataSource.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/10/25.
//

import Cocoa

class DNSRecordDataSource: NSObject, NSTableViewDataSource {
    var zoneDetails: ZoneDetails?

    func numberOfRows(in tableView: NSTableView) -> Int {
        return zoneDetails?.records.count ?? 0
    }
}
