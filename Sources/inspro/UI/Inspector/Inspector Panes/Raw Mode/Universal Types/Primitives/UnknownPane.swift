import SwiftUI
import InspectProfile

struct UnknownPane: View {

    let node: DERNode

    var body: some View {
        NodePaneHeader(node: node)
        InspectorGrid {
            EmptyView()
        }
    }
}
