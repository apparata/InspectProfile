import SwiftUI
import InspectProfile

struct BitStringPane: View {

    let node: DERNode
    
    let bitString: DERBitString

    @State private var string: String = ""

    @Environment(\.openWindow) private var openWindow

    var body: some View {
        NodePaneHeader(node: node)
            .task(id: node.id) {
                string = ""
                Task.detached {
                    let string = hexDump(bitString.value, bytesPerRow: 8)
                    await MainActor.run {
                        self.string = string
                    }
                }
            }
        TextEditor(text: .constant(string))
            .font(.custom("Menlo", size: 12))
            .overlay(alignment: .bottomTrailing) {
                Button {
                    openWindow(value: string)
                } label: {
                    Image(systemName: "pip.enter")
                        .imageScale(.large)
                        .padding(8)
                        .background(.thickMaterial)
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)
                .padding()
            }
            .overlay(alignment: .center) {
                if string == "" {
                    ProgressView()
                }
            }
    }
}
