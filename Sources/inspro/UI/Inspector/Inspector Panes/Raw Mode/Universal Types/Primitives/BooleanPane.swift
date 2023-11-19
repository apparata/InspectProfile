import SwiftUI
import InspectProfile

struct BooleanPane: View {

    let node: Node

    let boolean: DERBoolean

    var body: some View {
        InspectorPaneHeader(inspectable: node)
        InspectorGrid {
            EmptyView()
        }
    }
}
