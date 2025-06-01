//
//  TTL.swift
//  Ionic
//
//  Created by Jon Alaniz on 5/30/25.
//

import Foundation

enum TTL: Int, CaseIterable {
    case oneMinute = 60
    case fiveMinutes = 300
    case thirtyMinutes = 1800
    case oneHour = 3600
    case twoHours = 7200
    case threeHours = 10800
    case sixHours = 21600
    case twelveHours = 43200
    case twentyFourHours = 86400
    case fortyEightHours = 172800
    
    var description: String {
        switch self {
        case .oneMinute: return "1 minute"
        case .fiveMinutes: return "5 minutes"
        case .thirtyMinutes: return "30 minutes"
        case .oneHour: return "1 hour"
        case .twoHours: return "2 hours"
        case .threeHours: return "3 hours"
        case .sixHours: return "6 hours"
        case .twelveHours: return "12 hours"
        case .twentyFourHours: return "24 hours"
        case .fortyEightHours: return "48 hours"
        }
    }
}
