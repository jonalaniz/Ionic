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
        guard tableView.selectedRowIndexes.count > 0 else { return }
        dataManager.fetchDynamicDNSURL(for: tableView.selectedRowIndexes)
    }
    
    @IBAction func copyPressed (_ sender: Any) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(urlTextField.stringValue, forType: .string)

        let content = urlTextField.stringValue
        urlTextField.stringValue = "URL Copied to Clipboard"

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.urlTextField.stringValue = content
        }
    }
}

extension DynamicDNSViewController: DynamicDNSDataManagerDelegate {
    func selectionDidChange() {
        let indexes = tableView.selectedRowIndexes
        getURLButton.isEnabled = indexes.count > 0 ? true : false
    }

    func urlCaptured(_ urlString: String) {
        urlTextField.stringValue = urlString
        copyButton.isEnabled = true
    }
}
