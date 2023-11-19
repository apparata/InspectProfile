import SwiftUI
import InspectProfile

struct UTF8StringPane: View {

    let node: Node

    let utf8String: DERUTF8String

    var body: some View {
        InspectorPaneHeader(inspectable: node)
        InspectorGrid {
            EmptyView()
        }
    }
}
