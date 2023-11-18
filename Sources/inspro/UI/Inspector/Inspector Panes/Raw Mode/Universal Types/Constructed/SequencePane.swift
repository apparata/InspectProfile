import SwiftUI
import InspectProfile

struct SequencePane: View {

    let node: DERNode

    let sequence: DERSequence

    var body: some View {
        NodePaneHeader(node: node)
        InspectorGrid {
            EmptyView()
        }
    }
}
