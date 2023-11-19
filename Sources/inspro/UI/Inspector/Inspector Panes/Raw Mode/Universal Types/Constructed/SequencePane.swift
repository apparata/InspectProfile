import SwiftUI
import InspectProfile

struct SequencePane: View {

    let node: DERNode

    let sequence: DERSequence

    var body: some View {
        InspectorPaneHeader(inspectable: node)
        InspectorGrid {
            EmptyView()
        }
    }
}
