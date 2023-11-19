import SwiftUI
import InspectProfile

struct OctetStringPane: View {

    let node: DERNode

    let octetString: DEROctetString

    var body: some View {
        InspectorPaneHeader(inspectable: node)
        InspectorHexDump(data: octetString.value)
    }
}
