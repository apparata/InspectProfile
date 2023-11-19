import SwiftUI
import InspectProfile

struct NullPane: View {

    let node: Node

    let null: DERNull

    var body: some View {
        InspectorPaneHeader(inspectable: node)
        InspectorGrid {
            EmptyView()
        }
    }
}
