//
//  InspectorViewController.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/13/25.
//

import Cocoa

class InspectorViewController: NSViewController {
    @IBOutlet weak var noSelectionLabel: NSTextField!

    var dnsRecord: DNSRecord? {
        didSet {
            toggleInspector(itemIsSelected: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toggleInspector(itemIsSelected: false)
    }

    func toggleInspector(itemIsSelected: Bool) {
        noSelectionLabel.isHidden = !itemIsSelected
    }

}
