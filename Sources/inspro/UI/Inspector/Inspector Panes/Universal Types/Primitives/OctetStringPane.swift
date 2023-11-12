import SwiftUI
import InspectProfile

struct OctetStringPane: View {

    let node: DERNode

    let octetString: DEROctetString

    var body: some View {
        NodePaneHeader(node: node)
        InspectorHexDump(node: node, data: octetString.value)
    }
}
