import SwiftUI

struct ViewCommands: Commands {

    @AppStorage(\AppSettings.textScale) private var textScale

    var body: some Commands {

        CommandGroup(after: .sidebar) {
            Divider()
            Button {
                textScale = min(10, textScale + 0.06)
            } label: {
                Text("Increase Text Size")
            }
            .keyboardShortcut("+")
            Button {
                textScale = max(0.4, textScale - 0.06)
            } label: {
                Text("Decrease Text Size")
            }
            .keyboardShortcut("-")
            Button {
                textScale = 1.0
            } label: {
                Text("Reset Text Size")
            }
            .keyboardShortcut("0")
            Divider()
        }
    }
}
