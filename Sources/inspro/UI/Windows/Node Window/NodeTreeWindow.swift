import SwiftUI

struct NodeTreeWindow: Scene {

    static let windowID = "nodetree"

    var body: some Scene {
        WindowGroup(id: Self.windowID, for: WindowData.self) { windowData in
            if let windowData = windowData.wrappedValue {
                NodeTree(title: windowData.title, data: windowData.data)
                    .frame(minWidth: 400, maxWidth: .infinity,
                           minHeight: 300, maxHeight: .infinity)
            }
        }
        .windowResizability(.automatic)
        .commands {
            AppCommands()
        }
    }
}
