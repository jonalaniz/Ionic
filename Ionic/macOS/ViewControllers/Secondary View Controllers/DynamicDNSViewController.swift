//
//  DynamicDNSViewController.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/17/25.
//

import Cocoa

class DynamicDNSViewController: NSViewController {
    // MARK: - Outloets

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var getURLButton: NSButton!
    @IBOutlet weak var copyButton: NSButton!
    @IBOutlet weak var urlTextField: NSTextField!

    // MARK: - Properties

    private let dataManager = DynamicDNSDataManager.shared

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    // MARK: - Configuration

    private func configure() {
        dataManager.delegate = self
        tableView.delegate = dataManager
        tableView.dataSource = dataManager
    }

    // MARK: - Actions

    @IBAction func copyPressed (_ sender: Any) {
        let content = urlTextField.stringValue

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(content, forType: .string)

        urlTextField.showCopyConfirmation(for: content)
    }

    @IBAction func getURLPressed(_ sender: Any) {
        guard !tableView.selectedRowIndexes.isEmpty else { return }
        dataManager.fetchDynamicDNSURL(for: tableView.selectedRowIndexes)
    }
}

// MARK: - DynamicDNSDataManagerDelegate

extension DynamicDNSViewController: DynamicDNSDataManagerDelegate {
    func selectionDidChange() {
        getURLButton.isEnabled = !tableView.selectedRowIndexes.isEmpty
    }

    func urlCaptured(_ urlString: String) {
        urlTextField.stringValue = urlString
        urlTextField.isEnabled = true
        copyButton.isEnabled = true
    }
}
