import SwiftUI
import InspectProfile

struct NullPane: View {

    let node: DERNode

    let null: DERNull

    var body: some View {
        NodePaneHeader(node: node)
        InspectorGrid {
            EmptyView()
        }
    }
}
