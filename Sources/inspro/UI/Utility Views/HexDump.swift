import SwiftUI

struct HexDump: View {

    let data: Data

    @State private var string: String?

    var body: some View {
        VStack {
            TextEditor(text: .constant(string ?? ""))
                .font(.custom("Menlo", size: 12))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay {
                    if string == nil {
                        ProgressView()
                    }
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            Task.detached {
                let string = hexDump(data, bytesPerRow: 16)
                await MainActor.run {
                    self.string = string
                }
            }
        }
    }
}
