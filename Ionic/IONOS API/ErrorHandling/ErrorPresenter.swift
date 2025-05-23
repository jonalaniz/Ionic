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
    let style: NSAlert.Style
}

class ErrorPresenter {
    static let shared = ErrorPresenter()
        
    func presentError(_ error: APIManagerError, in window: NSWindow) {
        let alert = NSAlert()
        let content = createAlertContent(for: error)
        
        alert.messageText = content.messageText
        alert.alertStyle = content.style
        alert.informativeText = content.informativeText ?? ""
        alert.addButton(withTitle: "OK")
        alert.beginSheetModal(for: window)
    }
    
    private func createAlertContent(for error: APIManagerError) -> AlertContent {
        switch error {
        case .ionosAPIError(let iONOSAPIError):
            return parseIONOSAPIError(iONOSAPIError)
        case .serializationFailed(let serializationError):
            return AlertContent(messageText: error.errorDescription,
                                informativeText: serializationError.localizedDescription,
                                style: .critical)
        case .somethingWentWrong(let error):
            return AlertContent(messageText: "Something went wrong",
                                informativeText: error?.localizedDescription,
                                style: .critical)
        default:
            return AlertContent(messageText: error.errorDescription,
                                informativeText: nil,
                                style: .critical)
        }
    }
    
    private func parseIONOSAPIError(_ error: IONOSAPIError) -> AlertContent {
        guard let data = error.responseData else {
            return AlertContent(messageText: "A server error occurred",
                                informativeText: "Unable to parse error from server.",
                                style: .critical)
        }
        
        switch error.code {
        // Error code 400 returns a `APIErrorInvalidResponse`
        case .badRequest:
            return badRequestErrorContent(from: data, statusCode: error.code.rawValue)
            
        // Rate limit exceeded returns nothing
        case .rateLimitExceeded:
            return AlertContent(messageText: error.localizedDescription,
                                informativeText: nil,
                                style: .critical)
            
        // 500 - Internal Server Error
        // Code only, no message
        case .internalServerError:
            return AlertContent(messageText: error.code.message,
                                informativeText: nil,
                                style: .critical)
            
        // 401 - Unauthorized
        // 403 - Forbidden
        // 404 - RecordNotFound
        default:
            return defaultAPIErrorContent(from: data, statusCode: error.code.rawValue)
        }
    }
    
    // TODO: Fix this
    private func badRequestErrorContent(from data: Data, statusCode: Int) -> AlertContent {
        return AlertContent(messageText: "", informativeText: "" , style: .warning)
    }
    
    /// This function parses the data for `401`, `403`, `404` errors
    /// Decodes `APIErrorCodeResponse` with message value and returns `AlertContent` object
    private func defaultAPIErrorContent(from data: Data, statusCode: Int) -> AlertContent {
        if let response = try? JSONDecoder().decode(APIErrorCodeResponse.self, from: data) {
            return AlertContent(messageText: response.code,
                                informativeText: response.message,
                                style: .critical)
        }
        
        return AlertContent(messageText: "API Error Occurred. Status Code: \(statusCode)",
                            informativeText: "Unable to parse error message from server.",
                            style: .critical)
    }
}
