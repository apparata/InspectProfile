import SwiftUI
import InspectProfile

struct ContextDefinedPrimitivePane: View {

    let node: DERNode

    let contextDefinedPrimitive: DERContextDefinedPrimitive

    var body: some View {
        NodePaneHeader(node: node)
        InspectorGrid {
            EmptyView()
        }
    }
}
