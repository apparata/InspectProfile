import SwiftUI
import InspectProfile

struct RawDataPane: View {

    let node: DERNode

    let data: Data

    var body: some View {
        NodePaneHeader(node: node)
        InspectorHexDump(node: node, data: data)
    }
}
