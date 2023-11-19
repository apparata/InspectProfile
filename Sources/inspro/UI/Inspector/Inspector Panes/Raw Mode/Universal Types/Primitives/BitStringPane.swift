import SwiftUI
import InspectProfile

struct BitStringPane: View {

    let node: Node
    
    let bitString: DERBitString

    @State private var string: String = ""

    @Environment(\.openWindow) private var openWindow

    var body: some View {
        InspectorPaneHeader(inspectable: node)
        InspectorHexDump(data: bitString.value)
    }
}
