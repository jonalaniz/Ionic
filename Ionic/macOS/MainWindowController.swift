//
//  MainWindowController.swift
//  Ionic
//
//  Created by Jon Alaniz on 3/22/25.
//

import Cocoa

class MainWindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(transitionToSplitView), name: .zonesDidChange, object: nil)
    }

    @objc private func transitionToSplitView() {
        guard
            let splitVC = storyboard?.instantiateController(withIdentifier: "MainContentSplitViewController") as? NSSplitViewController,
            let window = window,
            let currentVC = window.contentViewController
        else {
            return
        }

        if currentVC is NSSplitViewController { return }
        // Prepare the new view controller
        splitVC.view.alphaValue = 0  // Start fully transparent
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
            }
        })
    }
}
