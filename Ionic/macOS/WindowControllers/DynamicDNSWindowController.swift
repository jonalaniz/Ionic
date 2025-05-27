//
//  DynamicDNSWindowController.swift
//  Ionic
//
//  Created by Jon Alaniz on 5/26/25.
//

import Cocoa

class DynamicDNSWindowController: NSWindowController {
    override func windowDidLoad() {
        DynamicDNSDataManager.shared.errorHandler = self
    }
}

extension DynamicDNSWindowController: ErrorHandling {
    func handle(error: APIManagerError, from source: ErrorSource) {
        guard source == .ddnsDataManager else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.presentError(error)
        }
    }
    
    private func presentError(_ error: APIManagerError) {
        print(error.errorDescription)
        guard let window = self.window else {
            assertionFailure("DynamicDNSWindowController.window was nil while presenting an error")
            return
        }
        
        ErrorPresenter.shared.presentError(error, in: window)
    }
}
