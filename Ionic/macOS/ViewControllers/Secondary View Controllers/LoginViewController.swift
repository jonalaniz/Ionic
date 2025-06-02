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
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var saveCheckmark: NSButton!

    let coordinator = DNSDataManagerCoordinator.shared

    override func awakeFromNib() {
        super.awakeFromNib()
        subscribeToNotifications()
        setupTextFields()
        loadAPIKey()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupTextFields() {
        publicKeyField.delegate = self
        privateKeyField.delegate = self
    }
    
    @IBAction func connect(_ sender: NSButton?) {
        guard publicKeyField.stringValue != "" && privateKeyField.stringValue != "" else { return }
        progressIndicator.startAnimation(nil)
        login(saveCheckmark.state == .on,
              publicKey: publicKeyField.stringValue,
              privateKey: privateKeyField.stringValue)
    }
    
    @objc private func toggleProgressView(_ notification: Notification) {
        if notification.name == .zonesDidChange {
            progressIndicator.stopAnimation(nil)
        }
    }

    private func loadAPIKey() {
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
    
    private func updateConnectButton() {
        connectButton.isEnabled = !publicKeyField.stringValue.isEmpty && !privateKeyField.stringValue.isEmpty
    }
}

extension LoginViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        updateConnectButton()
    }
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(insertNewline) {
            guard connectButton.isEnabled else { return false }
            connect(nil)
            return true
        }
        return false
    }
}
