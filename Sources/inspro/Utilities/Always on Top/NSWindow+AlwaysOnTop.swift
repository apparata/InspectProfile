//
//  Copyright © 2023 Apparata AB. All rights reserved.
//

import AppKit

public extension NSWindow {
    
    var alwaysOnTop: Bool {
        get {
            return level.rawValue >= Int(CGWindowLevelForKey(CGWindowLevelKey.statusWindow))
        }
        set {
            if newValue {
                makeKeyAndOrderFront(nil)
                level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(CGWindowLevelKey.statusWindow)))
            } else {
                level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(CGWindowLevelKey.normalWindow)))
            }
        }
    }
}