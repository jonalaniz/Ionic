//
//  ErrorPresenter.swift
//  Ionic
//
//  Created by Jon Alaniz on 5/17/25.
//

import Cocoa

struct AlertContent {
    let messageText: String
    let informativeText: String?
    let alertStyle: NSAlert.Style = .critical
}

class ErrorPresenter {
    static let shared = ErrorPresenter()
    
    func presentError(_ error: APIManagerError, in window: NSWindow) {
//        let alert = NSAlert()
//        let content = createAlertContent(for: error)
//
//        alert.messageText =
//        alert.alertStyle = .critical
    }
    
//    private func createAlertContent(for error: APIManagerError) -> AlertContent {
//        switch error {
//        case .configurationMissing: return
//        case .conversionFailedToHTTPURLResponse: return
//        case .invalidResponse(let code):
//            return AlertContent(messageText: "Invalid Response",
//                                informativeText: "Server returned status code: \(code)")
//        case .invalidURL: return
//        case .ionosAPIErrorCode(let ionosError):
//            return AlertContent(messageText: ionosError.message, informativeText: <#T##String?#>)
//        case .serializaitonFailed: return
//        case .somethingWentWrong(let error): return
//        }
//    }
}
