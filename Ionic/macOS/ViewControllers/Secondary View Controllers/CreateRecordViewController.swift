//
//  CreateRecordViewController.swift
//  Ionic
//
//  Created by Jon Alaniz on 5/27/25.
//

import Cocoa

// swiftlint:disable notification_center_detachment
class CreateRecordViewController: NSViewController {
    // MARK: - Outlets

    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var recordTypeButton: NSPopUpButton!
    @IBOutlet weak var contentLabel: NSTextField!
    @IBOutlet weak var contentTextField: NSTextField!
    @IBOutlet weak var ttlPopupButton: NSPopUpButton!
    @IBOutlet weak var priorityTextLabel: NSTextField!
    @IBOutlet weak var priorityTextField: NSTextField!
    @IBOutlet weak var recordTypeLabel: NSTextField!
    @IBOutlet weak var recordTypeDescriptionTextField: NSTextField!
    @IBOutlet weak var recordPreviewTextField: NSTextField!
    @IBOutlet weak var createRecordButton: NSButton!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!

    // MARK: - Properties

    private let recordManager = DNSRecordDataManager.shared

    private var selectedTTL: TTL? {
        ttlPopupButton.selectedItem?.representedObject as? TTL
    }

    private var selectedRecordType: RecordType? {
        recordTypeButton.selectedItem?.representedObject as? RecordType
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewWillDisappear() {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Configuration

    private func configure() {
        setupNotifications()
        setupMenus()
        setupTextFields()
        updatePreview()
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dismissController),
            name: .recordCreated,
            object: nil)
    }

    private func setupMenus() {
        setupRecordTypeMenu()
        setupTTLMenu()
    }

    private func setupRecordTypeMenu() {
        guard let menu = recordTypeButton.menu else { return }
        menu.removeAllItems()

        for type in RecordType.allCases where !type.experimental() {
            let item = NSMenuItem(
                title: type.rawValue,
                action: #selector(didSelectRecordType),
                keyEquivalent: ""
            )

            item.representedObject = type
            item.target = self
            menu.addItem(item)
        }
    }

    private func setupTTLMenu() {
        guard let menu = ttlPopupButton.menu else { return }
        menu.removeAllItems()

        for ttl in TTL.allCases {
            let item = NSMenuItem(
                title: "\(ttl.rawValue) (\(ttl.description))",
                action: #selector(didSelectTTL),
                keyEquivalent: ""
            )

            item.representedObject = ttl
            item.target = self
            menu.addItem(item)
        }

        ttlPopupButton.selectItem(at: 3)
    }

    private func setupTextFields() {
        nameTextField.delegate = self
        contentTextField.delegate = self
        priorityTextField.delegate = self
    }

    // MARK: - Actions

    @IBAction func createRecord(_ sender: NSButton) {
        guard
            let ttl = selectedTTL,
            let type = selectedRecordType
        else { return }
        let prio: Int? = priorityTextField.isEnabled ? Int(priorityTextField.stringValue) : nil
        recordManager.createRecord(
            name: nameTextField.stringValue,
            type: type,
            content: contentTextField.stringValue,
            ttl: ttl,
            prio: prio
        )
        progressIndicator.startAnimation(nil)
    }

    @objc private func didSelectRecordType(_ sender: NSMenuItem) {
        guard let type = sender.representedObject as? RecordType else { return }
        updateUI(for: type)
        updatePreview()
        checkForValidRecord()
    }

    @objc private func didSelectTTL(_ sender: NSMenuItem) {
        updatePreview()
        checkForValidRecord()
    }

    @objc private func dismissController() {
        self.dismiss(self)
    }

    // MARK: - UI Updates

    @objc private func updatePreview() {
        guard
            let domain = recordManager.selectedZone?.name,
            let ttl = ttlPopupButton.selectedItem?.representedObject as? TTL,
            let recordType = recordTypeButton.selectedItem?.representedObject as? RecordType
        else {
            assertionFailure("Missing required DNS record components.")
            return
        }

        let host = makeHostName(nameTextField.stringValue)
        let previewString = "\(host)\(domain) \(ttl.rawValue) IN \(recordType.rawValue) \(contentTextField.stringValue)"
        recordPreviewTextField.placeholderString = previewString
    }

    private func updateUI(for type: RecordType) {
        recordTypeLabel.stringValue = "\(type.name):"
        recordTypeDescriptionTextField.stringValue = type.description

        contentLabel.stringValue = type.contentLabel + ":"

        let priority = type.requiresPriority()
        priorityTextField.isEnabled = priority
        priorityTextLabel.textColor = priority ? .labelColor : .secondaryLabelColor
    }

    // MARK: - Validation

    private func checkForValidRecord() {
        guard let type = recordTypeButton.selectedItem?.representedObject as? RecordType else {
            assertionFailure("Record Type was not set in CreateRecordController")
            return
        }

        let isContentValid = contentTextField.stringValue != ""

        if type.requiresPriority() {
            createRecordButton.isEnabled = isContentValid && priorityTextField.stringValue != ""
        } else {
            createRecordButton.isEnabled = isContentValid
        }
    }

    // MARK: Helper Methods
    private func makeHostName(_ name: String) -> String {
        guard !name.isEmpty, name != "@" else { return "" }
        return "\(name)."
    }
}

// MARK: - NSTextFieldDelegate

extension CreateRecordViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        updatePreview()
        checkForValidRecord()
    }
}
