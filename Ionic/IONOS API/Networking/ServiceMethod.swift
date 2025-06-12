//
//  ServiceMethod.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/8/25.
//

import Foundation

/// An enumeration representing supported HTTP request methods.
enum ServiceMethod: String {
    /// The HTTP GET method, typically used for retrieving data.
    case get = "GET"

    /// The HTTP POST method, typically used for creating new resources.
    case post = "POST"

    /// The HTTP PUT method, typically used for updating existing resources.
    case put = "PUT"

    /// The HTTP DELETE method, typically used for deleting resources.
    case delete = "DELETE"}
