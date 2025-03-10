//
//  Toolbar.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/9/25.
//

import Cocoa

class Toolbar: NSToolbar {
    @IBOutlet weak var publicKeyField: NSTextField!
    @IBOutlet weak var privateKeyField: NSSecureTextField!
    @IBOutlet weak var connectButton: NSButton!
    @IBOutlet weak var circularProgressView: NSProgressIndicator!

    let dataManager = IONOSDataManager.shared

    private let publicKey = ""
    private let privateKey = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        publicKeyField.stringValue = publicKey
        privateKeyField.stringValue = privateKey
    }

    @IBAction func connect(_ sender: NSButton) {
        guard publicKeyField.stringValue != "" && privateKeyField.stringValue != "" else { return }
        dataManager.setKeys(publicKey: publicKeyField.stringValue, privateKey: privateKeyField.stringValue)
    }
}
