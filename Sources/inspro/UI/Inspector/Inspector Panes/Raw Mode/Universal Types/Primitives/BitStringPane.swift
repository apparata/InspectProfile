import SwiftUI
import InspectProfile

struct BitStringPane: View {

    let node: Node
    
    let bitString: DERBitString

    @State private var string: String = ""

    var body: some View {
        InspectorPaneHeader(inspectable: node)
        InspectorHexDump(title: node.type, data: bitString.value)
    }
}
