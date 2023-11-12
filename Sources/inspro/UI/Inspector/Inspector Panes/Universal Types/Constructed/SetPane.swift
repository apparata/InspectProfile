import SwiftUI
import InspectProfile

struct SetPane: View {

    let node: DERNode

    let set: DERSet

    var body: some View {
        NodePaneHeader(node: node)
        InspectorGrid {
            EmptyView()
        }
    }
}
