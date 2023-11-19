import SwiftUI
import InspectProfile

struct ContextDefinedConstructedPane: View {

    let node: DERNode

    let contextDefinedConstructed: DERContextDefinedConstructed

    var body: some View {
        InspectorPaneHeader(inspectable: node)
        InspectorGrid {
            EmptyView()
        }
    }
}
