import SwiftUI
import InspectProfile

struct BooleanPane: View {

    let node: DERNode

    let boolean: DERBoolean

    var body: some View {
        NodePaneHeader(node: node)
        InspectorGrid {
            EmptyView()
        }
    }
}
