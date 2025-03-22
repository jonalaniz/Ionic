//
//  String+ReadableDate.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/22/25.
//

import Foundation

extension String {
    func readableDate() -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = isoFormatter.date(from: self) else { return "Invalid date format" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy, h:mm a"
        dateFormatter.timeZone = .current

        let readableDate = dateFormatter.string(from: date)
        return readableDate
    }
}
