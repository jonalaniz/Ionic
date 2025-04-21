//
//  NSTextField+ShowCopyConfirmation.swift
//  Ionic
//
//  Created by Jon Alaniz on 4/21/25.
//

import Cocoa

extension NSTextField {
    func showCopyConfirmation(for string: String) {
        isEnabled = false
        stringValue = "URL Copied to Clipboard"

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isEnabled = true
            self.stringValue = string
        }
    }
}
