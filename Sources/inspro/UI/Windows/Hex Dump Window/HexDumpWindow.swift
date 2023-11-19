import SwiftUI

struct HexDumpWindow: Scene {

    static let windowID = "hexdump"

    var body: some Scene {
        WindowGroup(id: Self.windowID, for: WindowData.self) { windowData in
            if let windowData = windowData.wrappedValue {
                HexDump(data: windowData.data)
                    .frame(minWidth: 562, maxWidth: 562,
                           minHeight: 600, maxHeight: .infinity)
                    .navigationTitle("\(windowData.data.count) bytes")
            }
        }
        .windowResizability(.contentSize)
    }
}
