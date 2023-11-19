import SwiftUI
import InspectProfile

struct ContextDefinedConstructedPane: View {

    let node: Node

    let contextDefinedConstructed: DERContextDefinedConstructed

    var body: some View {
        InspectorPaneHeader(inspectable: node)
        InspectorGrid {
            EmptyView()
        }
    }
}
