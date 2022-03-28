//
//  StatusBarController.swift
//  ConnectionStatus
//
//  Created by Essence K on 28.03.2022.
//

import AppKit
import Foundation

class StatusBarController {

    // MARK: - Ping delay & URL
    private let pingDelay: Double = 0.5
    private let pingURL: URL? = URL(string: "https://apple.com")

    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var popover: NSPopover

    init(_ popover: NSPopover) {
        self.popover = popover
        statusBar = NSStatusBar.init()
        statusItem = statusBar.statusItem(withLength: 28.0)
        
        if let statusBarButton = statusItem.button {
            setUpImage()
            statusBarButton.action = #selector(togglePopover(sender:))
            statusBarButton.target = self
        }
        ping()
    }

    private func ping() {
        if let url = pingURL {
            var request = URLRequest(url: url)
            request.httpMethod = "HEAD"

            URLSession(configuration: .default)
                .dataTask(with: request) { (_, response, error) -> Void in
                    guard error == nil else {
                        print("Error:", error ?? "")
                        self.setDownImage()
                        self.ping()
                        return
                    }

                    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                        self.setDownImage()
                        self.ping()
                        return
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.pingDelay) {
                        self.ping()
                    }
                    self.setUpImage()
                }.resume()
        }
    }

    private func setDownImage() {
        DispatchQueue.main.async {
            if let statusBarButton = self.statusItem.button {
                let image = NSImage(imageLiteralResourceName: "down_arrow")
                statusBarButton.image = image
                statusBarButton.image?.size = NSSize(width: 18.0, height: 10.0)
                statusBarButton.image?.isTemplate = true
            }
        }
    }

    private func setUpImage() {
        DispatchQueue.main.async {
            if let statusBarButton = self.statusItem.button {
                let image = NSImage(imageLiteralResourceName: "up_arrow")
                statusBarButton.image = image
                statusBarButton.image?.size = NSSize(width: 18.0, height: 10.0)
                statusBarButton.image?.isTemplate = true
            }
        }
    }

    @objc func togglePopover(sender: AnyObject) {
        if(popover.isShown) {
            hidePopover(sender)
        }
        else {
            showPopover(sender)
        }
    }
    
    func showPopover(_ sender: AnyObject) {
        if let statusBarButton = statusItem.button {
            popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
        }
    }
    
    func hidePopover(_ sender: AnyObject) {
        popover.performClose(sender)
    }
}
