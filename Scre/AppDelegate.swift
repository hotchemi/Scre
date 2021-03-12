import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    @AppStorage(Config.Key.windowFrame.rawValue) private var windowFrame = ""

    var window: NSWindow? {
        NSApplication.shared.windows.first
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        guard let window = window else {
            return
        }
        window.setFrame(NSRectFromString(windowFrame), display: true)
        window.setSizeAsTitle()
        window.tabbingMode = .disallowed
        window.isOpaque = false
        window.backgroundColor = NSColor.clear
        window.contentView?.wantsLayer = true
        window.contentView?.layer?.borderColor = NSColor.windowBackgroundColor.cgColor
        window.contentView?.layer?.borderWidth = 2
        window.contentView?.layer?.allowsEdgeAntialiasing = true
        window.delegate = self
        window.makeKeyAndOrderFront(nil)
        window.toggleMoving(enabled: true)

        NotificationCenter.default.addObserver(self, selector: #selector(didResizeNotification(notification:)), name: NSWindow.didResizeNotification, object: nil)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}

// MARK: - Command Menu
extension AppDelegate {
    @IBAction func showHelp(_ sender: Any) {
        guard let url = URL(string: "https://github.com/hotchemi/Scre") else {
            return
        }
        NSWorkspace.shared.open(url)
    }
}

// MARK: - NSWindow.didResizeNotification
extension AppDelegate {
    @objc func didResizeNotification(notification: Notification) {
        window?.setSizeAsTitle()
    }
}

// MARK: - NSWindowDelegate
extension AppDelegate : NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        NotificationCenter.default.removeObserver(self)
        if let frame = window?.frame {
            windowFrame = NSStringFromRect(frame)
        }
    }
}

