import SwiftUI
import InspectProfile

struct BooleanPane: View {

    let node: DERNode

    let boolean: DERBoolean

    var body: some View {
        InspectorPaneHeader(inspectable: node)
        InspectorGrid {
            EmptyView()
        }
    }
}
