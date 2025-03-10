//
//  Column.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/9/25.
//

import Cocoa

enum Column: String {
    case Zone = "ZoneColumn"
    case ID = "IDColumn"
    case ZoneType = "TypeColumn"

    init?(from identifier: NSUserInterfaceItemIdentifier?) {
        guard let id = identifier?.rawValue else { return nil }
        self.init(rawValue: id)
    }

    var cellIdentifier: String {
        switch self {
        case .Zone: return "ZoneCell"
        case .ID: return "IDCell"
        case .ZoneType: return "TypeCell"
        }
    }
}
