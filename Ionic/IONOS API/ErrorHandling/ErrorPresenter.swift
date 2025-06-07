//
//  ErrorPresenter.swift
//  Ionic
//
//  Created by Jon Alaniz on 5/17/25.
//

import Cocoa

/// A structure that represents the content to be shown in an error alert.
struct AlertContent {
    let messageText: String
    let informativeText: String?
    let style: NSAlert.Style
}

/// A singleton class responsible for formatting and presenting API-related errors as `NSAlert` sheets.
class ErrorPresenter {

    /// Shared instance of the error presenter.
    static let shared = ErrorPresenter()

    private init() {}

    /// Presents a formatted error alert in the given window shown as a sheet.
    ///
    /// - Parameters:
    ///   - error: The API error to display.
    ///   - window: The window in which to present the alert.
    func presentErrorAsSheet(_ error: APIManagerError, in window: NSWindow) {
        let alert = createAlert(error)
        alert.beginSheetModal(for: window)
    }

    /// Presents a formatted error alert modally. Useful for errors when a modal sheet is already showing.
    ///
    /// - Parameters:
    ///   - error: The API error to display.
    func presentErrorAsModal(_ error: APIManagerError) {
        let alert = createAlert(error)
        alert.runModal()
    }

    private func createAlert(_ error: APIManagerError) -> NSAlert {
        let alert = NSAlert()
        let content = createAlertContent(for: error)
        alert.messageText = content.messageText
        alert.alertStyle = content.style
        alert.informativeText = content.informativeText ?? ""
        alert.addButton(withTitle: "OK")

        return alert
    }

    /// Converts an `APIManagerError` into displayable `AlertContent`.
    ///
    /// - Parameter error: The error to format.
    /// - Returns: An `AlertContent` object representing the alert's message, description, and style.
    private func createAlertContent(for error: APIManagerError) -> AlertContent {
        switch error {
        case .ionosAPIError(let iONOSAPIError):
            return parseIONOSAPIError(iONOSAPIError)
        case .serializationFailed(let serializationError):
            return AlertContent(
                messageText: error.errorDescription,
                informativeText: serializationError.localizedDescription,
                style: .critical
            )
        case .somethingWentWrong(let error):
            return AlertContent(
                messageText: "Something went wrong",
                informativeText: error?.localizedDescription,
                style: .critical
            )
        default:
            return AlertContent(
                messageText: error.errorDescription,
                informativeText: nil,
                style: .critical
            )
        }
    }

    /// Parses an `IONOSAPIError` into appropriate alert content based on its HTTP status code.
    ///
    /// - Parameter error: The `IONOSAPIError` containing error type and raw response data.
    /// - Returns: An `AlertContent` object representing the error alert.
    private func parseIONOSAPIError(_ error: IONOSAPIError) -> AlertContent {
        switch error.code {

        // 400 - Returns `APIErrorInvalidResponse`
        case .badRequest:
            return parseBadRequest(
                from: error.responseData,
                statusCode: error.code.rawValue
            )

        // 429 - Rate limit exceeded returns nothing
        // 500 - Internal Server Error - Returns object with no message
        case .rateLimitExceeded, .internalServerError:
            return AlertContent(
                messageText: error.code.message,
                informativeText: nil,
                style: .critical
            )

        // 401 - Unauthorized
        // 403 - Forbidden
        // 404 - RecordNotFound
        default:
            return parseGenericError(
                from: error.responseData,
                statusCode: error.code.rawValue
            )
        }
    }

    private func parseBadRequest(from data: Data?, statusCode: Int) -> AlertContent {
        guard
            let data = data,
            let response = try? JSONDecoder().decode([APIErrorInvalidResponse].self, from: data),
            let firstResponse = response.first
        else {
            return apiErrorFallback(
                statusCode: IONOSAPIErrorCode.badRequest.rawValue,
                informativeText: "Bad request: unable to parse error"
            )
        }
        let message = createMessageText(from: firstResponse)

        // For now just give it an empty object
        return AlertContent(messageText: firstResponse.code, informativeText: message, style: .warning)
    }

    /// Attempts to decode a standard API error from known 401, 403, and 404 status codes.
    ///
    /// - Parameters:
    ///   - data: The raw response data.
    ///   - statusCode: The HTTP status code associated with the error.
    /// - Returns: A formatted `AlertContent` or a fallback message.
    private func parseGenericError(from data: Data?, statusCode: Int) -> AlertContent {
        guard
            let data = data,
            let response = try? JSONDecoder().decode([APIErrorCodeResponse].self, from: data),
            let firstResponse = response.first
        else {
            return apiErrorFallback(
                statusCode: statusCode,
                informativeText: "Unable to parse error message"
            )
        }

        return apiErrorFallback(
            statusCode: statusCode,
            informativeText: firstResponse.message
        )
    }

    /// Creates a generic alert content structure to use when error details are missing or unparseable.
    ///
    /// - Parameters:
    ///   - statusCode: An optional HTTP status code to include in the alert.
    ///   - informativeText: Optional detail message.
    /// - Returns: A critical `AlertContent` fallback.
    private func apiErrorFallback(statusCode code: Int?, informativeText text: String?) -> AlertContent {
        let message = code.map { errorTitle(for: $0) } ?? "API Error"
        let informativeText = text ?? "An unknown error occurred."

        return AlertContent(
            messageText: message,
            informativeText: informativeText,
            style: .critical
        )
    }

    private func createMessageText(from response: APIErrorInvalidResponse) -> String {
        guard var message = response.message else {
            return "No message provided from API"
        }

        if let invalidFields = response.parameters?.invalidFields?.joined(separator: ",") {
            message.append("\n")
            message.append(contentsOf: "Invalid Fields: \(invalidFields)")
        }

        if let errorRecord = response.parameters?.errorRecord {
            message.append("\n")
            message.append("Record: \(errorRecord)")
        }

        return message
    }

    private func errorTitle(for statusCode: Int) -> String {
        return "An API error occurred, status code: \(statusCode)"
    }
}
