//
//  Copyright © 2023 Apparata AB. All rights reserved.
//

import SwiftUI
import AppKit
import InspectProfile

struct InsproApp: App {
    
    // swiftlint:disable:next weak_delegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        DispatchQueue.main.async {
            NSApp.setActivationPolicy(.regular)
            NSApp.activate(ignoringOtherApps: true)
            NSApp.windows.first?.makeKeyAndOrderFront(nil)
            NSApp.applicationIconImage = appIcon
        }
    }

    var body: some Scene {
        WindowGroup {
            ProvisioningProfiles()
                .frame(minWidth: 400, maxWidth: .infinity,
                       minHeight: 300, maxHeight: .infinity)
        }
        .windowResizability(.automatic)

        WindowGroup(for: Data.self) { data in
            if let data = data.wrappedValue {
                HexDumpView(data: data)
                    .frame(minWidth: 562, maxWidth: 562,
                           minHeight: 600, maxHeight: .infinity)
                    .navigationTitle("\(data.count) bytes")
            }
        }
        .windowResizability(.contentSize)
    }
}

// MARK: - App Delegate

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
