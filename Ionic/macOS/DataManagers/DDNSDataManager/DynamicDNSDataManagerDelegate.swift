//
//  DynamicDNSDataManagerDelegate.swift
//  Ionic
//
//  Created by Jon Alaniz on 6/9/25.
//

import Foundation

protocol DynamicDNSDataManagerDelegate: AnyObject {
    /// Called when the user selects one or more hostnames to generate a Dynamic DNS update URL.
    func selectionDidChange()

    /// Called when a dynamic DNS update URL is generated or captured.
    /// - Parameter urlString: The update URL as a `String`.
    func urlCaptured(_ urlString: String)
}
