//
//  DynamicDNSViewController.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/17/25.
//

import Cocoa

class DynamicDNSViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var getURLButton: NSButton!
    @IBOutlet weak var copyButton: NSButton!
    @IBOutlet weak var urlTextField: NSTextField!
    
    let dataManager = DynamicDNSDataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.delegate = self
        tableView.delegate = dataManager
        tableView.dataSource = dataManager
    }

    @IBAction func getURLPressed(_ sender: Any) {
        guard !tableView.selectedRowIndexes.isEmpty else { return }
        dataManager.fetchDynamicDNSURL(for: tableView.selectedRowIndexes)
    }
    
    @IBAction func copyPressed (_ sender: Any) {
        let content = urlTextField.stringValue

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(content, forType: .string)

        urlTextField.isEnabled = false
        urlTextField.stringValue = "URL Copied to Clipboard"

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.urlTextField.isEnabled = true
            self.urlTextField.stringValue = content
        }
    }
}

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
