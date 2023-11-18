import SwiftUI
import InspectProfile

struct UTF8StringPane: View {

    let node: DERNode

    let utf8String: DERUTF8String

    var body: some View {
        NodePaneHeader(node: node)
        InspectorGrid {
            EmptyView()
        }
    }
}
