import SwiftUI
import InspectProfile

struct BitStringPane: View {

    let node: DERNode
    
    let bitString: DERBitString

    @State private var string: String = ""

    @Environment(\.openWindow) private var openWindow

    var body: some View {
        NodePaneHeader(node: node)
        InspectorHexDump(node: node, data: bitString.value)
    }
}
