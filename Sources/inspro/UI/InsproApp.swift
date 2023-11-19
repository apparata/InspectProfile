import SwiftUI
import AppKit
import InspectProfile

struct InsproApp: App {
    
    // swiftlint:disable:next weak_delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @State var textZoom: CGFloat = 1

    init() {
        DispatchQueue.main.async {
            NSApp.setActivationPolicy(.regular)
            NSApp.activate(ignoringOtherApps: true)
            NSApp.windows.first?.makeKeyAndOrderFront(nil)
            NSApp.applicationIconImage = appIcon
        }
    }

    var body: some Scene {
        ProfilesWindow()
        NodeTreeWindow()
        HexDumpWindow()
    }
}

// MARK: - App Delegate

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
