import SwiftUI
import InspectProfile

struct ContextDefinedPrimitivePane: View {

    let node: DERNode

    let contextDefinedPrimitive: DERContextDefinedPrimitive

    var body: some View {
        InspectorPaneHeader(inspectable: node)
        InspectorHexDump(data: contextDefinedPrimitive.primitive)
    }
}
