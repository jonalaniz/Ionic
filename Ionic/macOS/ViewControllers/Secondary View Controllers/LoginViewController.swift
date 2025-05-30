//
//  LoginViewController.swift
//  Ionic
//
//  Created by Jon Alaniz on 4/15/25.
//

import Cocoa

class LoginViewController: NSViewController {
    @IBOutlet weak var connectButton: NSButton!
    @IBOutlet weak var publicKeyField: NSTextField!
    @IBOutlet weak var privateKeyField: NSTextField!
    @IBOutlet weak var progressindicator: NSProgressIndicator!
    @IBOutlet weak var saveCheckmark: NSButton!

    let coordinator = DNSDataManagerCoordinator.shared

    override func awakeFromNib() {
        super.awakeFromNib()
        subscribeToNotifications()
        publicKeyField.delegate = self
        privateKeyField.delegate = self
        checkForKey()
    }

    private func checkForKey() {
        guard let key = coordinator.apiKey else { return }
        publicKeyField.stringValue = key.publicKey
        privateKeyField.stringValue = key.privateKey
        updateConnectButton()
    }

    private func login(_ save: Bool, publicKey: String, privateKey: String) {
        let key = DNSAPIKey(name: "Internal",
                            publicKey: publicKey,
                            privateKey: privateKey)
        coordinator.connect(with: key, save: save)
    }

    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(toggleProgressView),
            name: .zonesDidChange,
            object: nil)
    }

    @IBAction func connect(_ sender: NSButton) {
        guard publicKeyField.stringValue != "" && privateKeyField.stringValue != "" else { return }
        progressindicator.startAnimation(nil)
        login(saveCheckmark.state == .on,
              publicKey: publicKeyField.stringValue,
              privateKey: privateKeyField.stringValue)
    }

    @objc private func toggleProgressView(_ notification: Notification) {
        if notification.name == .zonesDidChange {
            progressindicator.stopAnimation(nil)
        }
    }
}

extension LoginViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        updateConnectButton()
    }

    private func updateConnectButton() {
        connectButton.isEnabled = !publicKeyField.stringValue.isEmpty && !privateKeyField.stringValue.isEmpty
    }
}
