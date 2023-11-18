import SwiftUI
import InspectProfile

struct ContextDefinedConstructedPane: View {

    let node: DERNode

    let contextDefinedConstructed: DERContextDefinedConstructed

    var body: some View {
        NodePaneHeader(node: node)
        InspectorGrid {
            EmptyView()
        }
    }
}
