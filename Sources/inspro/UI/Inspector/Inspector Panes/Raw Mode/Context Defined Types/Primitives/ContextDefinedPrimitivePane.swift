import SwiftUI
import InspectProfile

struct ContextDefinedPrimitivePane: View {

    let node: Node

    let contextDefinedPrimitive: DERContextDefinedPrimitive

    var body: some View {
        InspectorPaneHeader(inspectable: node)
        InspectorHexDump(title: node.type, data: contextDefinedPrimitive.primitive)
    }
}
