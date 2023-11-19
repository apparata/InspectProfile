import SwiftUI
import InspectProfile

struct SequencePane: View {

    let node: Node

    let sequence: DERSequence

    var body: some View {
        InspectorPaneHeader(inspectable: node)
        InspectorGrid {
            EmptyView()
        }
    }
}
