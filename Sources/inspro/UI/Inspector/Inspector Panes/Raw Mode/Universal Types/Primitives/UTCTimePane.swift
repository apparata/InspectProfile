import SwiftUI
import InspectProfile

struct UTCTimePane: View {

    let node: DERNode

    let utcTime: DERUTCTime

    var body: some View {
        NodePaneHeader(node: node)
        InspectorGrid {
            EmptyView()
        }
    }
}
