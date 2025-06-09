//
//  MainWindowController.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/22/25.
//

import Cocoa

class MainWindowController: NSWindowController {
    // MARK: - Lifecycle
    override func windowDidLoad() {
        super.windowDidLoad()
        configure()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Configuration
    private func configure() {
        setupNotifications()
        window?.titleVisibility = .hidden
        ZoneDataManager.shared.errorHandler = self
        RecordDataManager.shared.errorHandler = self
        DynamicDNSDataManager.shared.errorHandler = self
    }

    // TODO: Add a "logged out" notification to show the loginView again
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(transitionToSplitView),
            name: .zonesDidChange,
            object: nil
        )
    }

    // MARK: - Actions

    @IBAction func reloadZones(_ sender: NSMenuItem) {
        DNSDataManagerCoordinator.shared.reloadZones()
    }

    // MARK: - Navigation

    // TODO: Factor out transition functionality
    @objc private func transitionToSplitView() {
        guard
            let splitVC = storyboard?.instantiateController(
                withIdentifier: "MainContentSplitViewController"
            ) as? NSSplitViewController,
            let window = window,
            let currentVC = window.contentViewController
        else {
            return
        }

        if currentVC is NSSplitViewController { return }

        // Prepare the new view controller (set transparent)
        splitVC.view.alphaValue = 0
        splitVC.view.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)

        // Perform the fade transition
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.2
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            // Fade out the old view
            currentVC.view.animator().alphaValue = 0

        }, completionHandler: {
            // Swap content view controller once fade-out completes
            window.contentViewController = splitVC

            // Fade in the new view
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.3
                splitVC.view.animator().alphaValue = 1
                window.titleVisibility = .visible
            }
        })
    }

    // MARK: - Helper Methods
    private func stopLoadingProgressIndicator() {
        guard let viewController = contentViewController as? LoginViewController else { return }
        viewController.progressIndicator.stopAnimation(nil)
    }
}

// MARK: - ErrorHandling
extension MainWindowController: ErrorHandling {
    func handle(error: APIManagerError, from source: ErrorSource) {
        DispatchQueue.main.async { [weak self] in
            switch source {
            case .zoneDataManager: self?.stopLoadingProgressIndicator()
            default: break
            }

            self?.presentError(error)
        }
    }

    private func presentError(_ error: APIManagerError) {
        guard let window = self.window else {
            assertionFailure("MailWindowController.window was nil while presenting an error")
            return
        }

        guard window.sheets.isEmpty else {
            ErrorPresenter.shared.presentErrorAsModal(error)
            return
        }

        ErrorPresenter.shared.presentErrorAsSheet(error, in: window)
    }
}
