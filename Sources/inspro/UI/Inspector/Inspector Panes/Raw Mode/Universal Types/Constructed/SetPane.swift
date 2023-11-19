import SwiftUI
import InspectProfile

struct SetPane: View {

    let node: Node

    let set: DERSet

    var body: some View {
        InspectorPaneHeader(inspectable: node)
        InspectorGrid {
            EmptyView()
        }
    }
}
